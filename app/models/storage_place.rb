class StoragePlace < ApplicationRecord
    validates :name, presence: true
    has_many :inventory_movements
end