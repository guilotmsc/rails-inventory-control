require 'rails_helper'

RSpec.describe StoragePlace, type: :model do
  
  context "attributes" do
    it "has name" do
      storage_place = StoragePlace.new(name: 'Storage Place X')
      expect(storage_place).to have_attributes(name: 'Storage Place X')
    end
  end
  

  context "validation" do
    it "is not valid without a name" do
      storage_place = StoragePlace.new(name: nil)
      expect(storage_place).to_not be_valid
    end

    it "valid storage_place" do
      storage_place = StoragePlace.new(name: 'Storage Place X')
      expect(storage_place).to be_valid
    end

    it "validate name error message" do
      storage_place = StoragePlace.new(name: nil)
      storage_place.valid?
      expect(storage_place.errors[:name]).to include("can't be blank")
    end
  end


  context "associations" do
    it "should have many movements" do
      storage_place = StoragePlace.reflect_on_association(:inventory_movements)
      expect(storage_place.macro).to eq(:has_many)
    end
  end
  
end
