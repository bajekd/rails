class LeadMailer < ApplicationMailer
  def lead_submission_notification
    lead = params[:lead]
    # do nothing, it's just an example
  end
end
