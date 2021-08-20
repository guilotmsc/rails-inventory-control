require 'rails_helper'

RSpec.describe Product, type: :model do
  
  context "attributes" do
    it "has name" do
      product = Product.new(name: 'Product')
      expect(product).to have_attributes(name: 'Product')
    end
  end
  

  context "validation" do
    it "is not valid without a name" do
      product = Product.new(name: nil)
      expect(product).to_not be_valid
    end

    it "is valid with name" do
      product = Product.new(name: 'Product A')
      expect(product).to be_valid
    end

    it "validate name error message" do
      product = Product.new(name: nil)
      product.valid?
      expect(product.errors[:name]).to include("can't be blank")
    end
  end


  context "associations" do
    it "should have many movements" do
      product = Product.reflect_on_association(:inventory_movements)
      expect(product.macro).to eq(:has_many)
    end
  end
  
end
