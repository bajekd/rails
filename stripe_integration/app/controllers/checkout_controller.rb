class CheckoutController < ApplicationController
  def create
    if @cart.pluck(:currency).uniq.length > 1
      redirect_to products_path, alert: "You can not select products with different currencies in one checkout!"
    end

    stripe_customer_id = current_user.stripe_customer_id || create_stripe_customer(current_user)

    @session = Stripe::Checkout::Session.create({
                                                  customer: stripe_customer_id,
                                                  payment_method_types: ['card'],
                                                  line_items: @cart.collect { |item| item.to_builder.attributes! },
                                                  allow_promotion_codes: true,
                                                  mode: 'payment',
                                                  success_url: success_url + '?session_id={CHECKOUT_SESSION_ID}',
                                                  cancel_url: cancel_url

                                                })

    respond_to do |format|
      format.js
    end
  end

  def success
    if params[:session_id].present?
      session.delete(:cart)
      @session_with_expand = Stripe::Checkout::Session.retrieve({
                                                                  id: params[:session_id],
                                                                  expand: ['line_items']
                                                                })

      @products = []
      @session_with_expand.line_items.data.each do |line_item|
        @products << Product.find_by(stripe_product_id: line_item.price.product)
      end

    else
      redirect_to cancel_url, alert: "No info to display"
    end
  end

  def cancel; end

  private

  def create_stripe_customer(user)
    stripe_customer = Stripe::Customer.create(email: user.email)
    user.update(stripe_customer_id: stripe_customer.id)

    stripe_customer
  end
end
