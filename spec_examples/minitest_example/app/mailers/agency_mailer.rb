class AgencyMailer < ApplicationMailer
  def lead_assigned_notification
    lead = params[:lead]
    # do nothing, it's just an example
  end
end
