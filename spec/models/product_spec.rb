require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    before do
      @category = Category.new(name: 'Test Category')
    end

    it 'validates presence of name' do
      product = Product.new(price: 100, quantity: 10, category: @category)
      product.name = nil
      expect(product).not_to be_valid
      expect(product.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of price' do
      product = Product.new(name: 'Test Product', quantity: 10, category: @category)
      product.price_cents = nil
      expect(product).not_to be_valid
      expect(product.errors[:price_cents]).to include("is not a number")
    end

    it 'validates presence of quantity' do
      product = Product.new(name: 'Test Product', price: 100, category: @category)
      product.quantity = nil
      expect(product).not_to be_valid
      expect(product.errors[:quantity]).to include("can't be blank")
    end

    it 'validates presence of category' do
      product = Product.new(name: 'Test Product', price: 100, quantity: 10)
      expect(product).not_to be_valid
      expect(product.errors[:category]).to include("can't be blank")
    end
  end
end
