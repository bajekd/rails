class Product < ApplicationRecord
  validates :name, :price, presence: true

  monetize :price, as: :price_cents

  def to_s
    name
  end

  def to_builder
    Jbuilder.new do |product|
      product.price stripe_price_id
      product.quantity 1
    end
  end

  after_update :create_and_assign_new_stripe_price, if: :saved_change_to_price?
  def create_and_assign_new_stripe_price
    price = Stripe::Price.create(product: self.stripe_product_id, unit_amount: self.price, currency: self.currency)

    update(stripe_price_id: price.id)
  end
end
