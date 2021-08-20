class InventoryMovement < ApplicationRecord
  validates :date, :movement_type, :quantity, presence: true

  belongs_to :product
  belongs_to :storage_place

  validate :is_valid_between_period?, :quantity_in_stock?, :is_movement_type_valid?

  def is_valid_between_period?
    return if date.blank?
    
    if date > Date.new(2021, 01, 01) and date < Date.new(2021, 01, 31)
      errors.add(:date, ' is outside the period allowed for the %s product of %s referring to %s' % [product.name, storage_place.name, date.strftime('%d/%m/%Y')])
    end
  end

  def quantity_in_stock?
    if movement_type == 'S'
      quantity_in_stock = calculate_quantity_of_product_in_stock(product, storage_place)

      if quantity_in_stock < quantity
        errors.add(:quantity, ' amount insufficient of %s in stock in %s on %s' % [product.name, storage_place.name, date.strftime('%d/%m/%Y')])
      end
    end
  end

  def is_movement_type_valid?
    valid_movement_types = ["E", "S"]

    if !valid_movement_types.include?(movement_type)
      errors.add(:movement_type, ' is invalid')
    end
  end

  def calculate_quantity_of_product_in_stock(product, storage_place)
    return InventoryMovement.where(product: product.id, storage_place_id: storage_place.id).sum(:quantity)
  end
end