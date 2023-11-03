class CheckoutController < ApplicationController
  def create
    stripe_customer_id = current_user.stripe_customer_id || create_stripe_customer(current_user)

    @session = Stripe::Checkout::Session.create({
                                                  customer: stripe_customer_id,
                                                  success_url: posts_url,
                                                  cancel_url: pricing_url,
                                                  payment_method_types: ['card'],
                                                  line_items: [{ price: params[:price], quantity: 1 }],
                                                  mode: 'subscription'
                                                })

    respond_to do |format|
      format.js
    end
  end

  private

  def create_stripe_customer(user)
    stripe_customer = Stripe::Customer.create(email: user.email)
    user.update(stripe_customer_id: stripe_customer.id)

    stripe_customer
  end
end
