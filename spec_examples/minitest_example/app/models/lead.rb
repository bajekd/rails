class Lead < ApplicationRecord
  DUPLICATE_TIME_WINDOW = 24.hours.freeze

  belongs_to :agency, optional: true, counter_cache: true
  belongs_to :agent, optional: true

  has_many :activity_logs

  enum :rejected_reason, {
    agent: 'agent',
    duplicate: 'duplicate',
    other: 'other'
  }, prefix: true

  enum :state, {
    pending: 'pending',
    rejected: 'rejected',
    new: 'new'
  }, prefix: true

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :rejected_reason, inclusion: { in: rejected_reasons.values, allow_nil: true }
  validates :state, inclusion: { in: states.values, allow_nil: true }

  # I'd consider moving those to ServiceObjects
  # it will be easier to test, and easier to reason about
  # without hid/implicite complexity that can be unexpected like Spanish Inquisition!
  # I haven't due to time constrain
  before_create :assign_agency
  after_create :send_notifications
  after_save :log_state_change

  # I'd consider moving those to QueryObjects, unless project tries to avoid those
  scope :duplicates, lambda { |phone:, email:, city_name:, address:, created_at:|
                       where(
                         phone:,
                         email:,
                         city_name:,
                         address:,
                         created_at: (created_at - DUPLICATE_TIME_WINDOW)..created_at
                       )
                     }

  scope :previous_leads, lambda { |phone:, email:, city_name:|
                           where('(phone = :phone OR email = :email) AND leads.city_name = :city_name', phone:, email:, city_name:)
                             .joins(:agency)
                             .includes(:agency)
                             .where('agencies.leads_count < agencies.leads_limit')
                             .order(created_at: :desc)
                         }

  private

  def assign_agency
    # Noteworthy changes:
    #   * added counter cache `Agency.leads_count`, to avoid n+1 queries
    #   * pick_agency can terminate without iterating through entire collection
    #
    # Some of below varables / lambdas could be extracted to separate methods
    # ( depeding on the style project uses )
    # I personally prefer having all the context (if possible) in one place

    belongs_to_agent = Agent.find_by_phone_or_email(phone:, email:).exists?
    lead_already_exist = Lead.duplicates(phone:, email:, city_name:, address:, created_at:).exists?
    belongs_to_sonarhome = email.end_with?('@sonarhome.pl')
    previous_lead = Lead.previous_leads(phone:, email:, city_name:).first

    pick_agency = lambda {
      agencies_with_leads_asc = Agency.in_city_with_leads_asc(city_name:)
      agencies_with_leads_asc.find do |a|
        break a if a.leads_count.zero?
        next if a.leads_count >= a.leads_limit

        percentage = ::MathHelper.percentage(a.leads_count, agencies_with_leads_asc.sum(&:leads_count))
        a.city_share_percentage.to_i > percentage
      end || agencies_with_leads_asc.find { |a| a.leads_count < a.leads_limit }
    }

    reject_lead = lambda { |reason:|
      self.state = Lead.states[:rejected]
      self.rejected_reason = reason
      self.agency = nil
    }

    assign_to_sonarhome_agency = lambda {
      self.state = Lead.states[:new]
      self.agency = Agency.sonarhome_agency
    }

    assign_previous_agency = lambda { |previous_lead|
      self.state = Lead.states[:new]
      self.agency = previous_lead.agency
    }

    return reject_lead.call(reason: Lead.rejected_reasons[:agent])     if belongs_to_agent
    return reject_lead.call(reason: Lead.rejected_reasons[:duplicate]) if lead_already_exist
    return assign_to_sonarhome_agency.call                             if belongs_to_sonarhome
    return assign_previous_agency.call(previous_lead)                  if previous_lead.present?

    agency = pick_agency.call

    if agency.present?
      self.state = Lead.states[:new]
      self.agency = agency
    else
      self.state = Lead.states[:pending]
      self.agency = nil
    end
  end

  def log_state_change
    return unless saved_change_to_state?

    activity_logs.create!(action: 'state_changed',
                          params: { state:, previous_state: state_before_last_save })
  end

  def send_notifications
    return if state == Lead.states[:rejected]

    AgencyMailer.with(lead: self).lead_assigned_notification.deliver_later if agency.present?
    LeadMailer.with(lead: self).lead_submission_notification.deliver_later
  end
end
