class WebhooksController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']
    event = nil

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, Rails.application.credentials.dig(Rails.env.to_sym, :stripe, :webhook)
      )

      rescue JSON::ParserError => e
        status 400
        return

      rescue Stripe::SignatureVerificationError => e
        puts 'Signature error'
        puts e
        return
    end

    case event.type
    when 'customer.subscription.updated', 'customer.subscription.deleted', 'customer.subscription.created'
      susbscription = event.data.object
      @user = User.find_by(stripe_customer_id: susbscription.customer)
      @user.update(
        subscription_status: susbscription.status,
        plan: susbscription.items.data[0].price.lookup_key,
        current_period_end: Time.at(susbscription.current_period_end).to_datetime
      )
    end

    render json: { message: 'success' }
  end
end