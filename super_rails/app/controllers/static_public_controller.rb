class StaticPublicController < ApplicationController
  skip_before_action :authenticate_user!

  def landing_page; end

  def about; end

  def privacy; end

  def terms; end

  def pricing
    @pricing = Stripe::Price.list(
      lookup_keys: %w[pro_monthly pro_yearly], expand: ['data.product']
    ).data.sort_by { |p| p.unit_amount }
  end
end
