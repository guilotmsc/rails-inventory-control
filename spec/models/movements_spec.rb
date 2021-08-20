require 'rails_helper'

RSpec.describe InventoryMovement, type: :model do
  
    it { is_expected.to validate_presence_of :date }
    it { is_expected.to validate_presence_of :movement_type }
    it { is_expected.to validate_presence_of :quantity }


    context "validation" do

        it "is not valid without a product" do
            storage_place = StoragePlace.new(name: 'Storage A')

            inventory_movement = InventoryMovement.new(product: nil, storage_place: storage_place, date: Date.new(2020, 01, 01), movement_type: 'A', quantity: 200)

            inventory_movement.valid?

            expect(inventory_movement).to_not be_valid
        end
        
        it "is not valid movement type" do
            product = Product.new(name: 'Product A')
            storage_place = StoragePlace.new(name: 'Storage A')

            inventory_movement = InventoryMovement.new(product: product, storage_place: storage_place, date: Date.new(2020, 01, 01), movement_type: 'A', quantity: 200)

            inventory_movement.valid?

            expect(inventory_movement).to_not be_valid
        end

        it "the amount of stock is insufficient" do
            product = Product.new(name: 'Product A')
            storage_place = StoragePlace.new(name: 'Storage A')

            inventory_movement = InventoryMovement.new(product: product, storage_place: storage_place, date: Date.new(2020, 01, 01), movement_type: 'S', quantity: 200)

            inventory_movement.valid?

            expect(inventory_movement.errors[:quantity]).to include(" amount insufficient of %s in stock in %s on %s"  % [product.name, storage_place.name, inventory_movement.date.strftime('%d/%m/%Y')])
        end

        it "the amount of stock is insufficient" do
            product = Product.new(name: 'Product A')
            storage_place = StoragePlace.new(name: 'Storage A')

            inventory_movement = InventoryMovement.new(product: product, storage_place: storage_place, date: Date.new(2020, 01, 01), movement_type: 'S', quantity: 200)

            inventory_movement.valid?

            expect(inventory_movement.errors[:quantity]).to include(" amount insufficient of %s in stock in %s on %s"  % [product.name, storage_place.name, inventory_movement.date.strftime('%d/%m/%Y')])
        end

    end


    context "integrity" do
    
        it "quantity in stock must be equals" do
            product = Product.new(name: 'Product A')
            storage_place = StoragePlace.new(name: 'Storage A')

            InventoryMovement.create(product: product, storage_place: storage_place, date: Date.new(2020, 01, 01), movement_type: 'E', quantity: 200)
            InventoryMovement.create(product: product, storage_place: storage_place, date: Date.new(2020, 01, 01), movement_type: 'S', quantity: 75)

            products_in = InventoryMovement.where(storage_place: storage_place, product: product, movement_type: 'E').sum(:quantity)
            products_out = InventoryMovement.where(storage_place: storage_place, product: product, movement_type: 'S').sum(:quantity)

            expect(products_in - products_out).to eq(125)
        end

    end
  
end
