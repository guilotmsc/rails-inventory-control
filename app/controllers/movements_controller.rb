require 'csv'

class MovementsController < ApplicationController

  def index
    # sql = "SELECT products.name as product_name, storage_places.name as storage_place_name, 
    #               sum(IFNULL(IIF(inventory_movements.movement_type = 'E', inventory_movements.quantity, 0), 0)) -
    #               sum(IFNULL(IIF(inventory_movements.movement_type = 'S', inventory_movements.quantity, 0), 0)) as quantity_total
    #         FROM inventory_movements
    #         INNER JOIN products ON products.id = inventory_movements.product_id
    #         INNER JOIN storage_places ON storage_places.id = inventory_movements.storage_place_id
    #         GROUP BY product_id, storage_place_id"

    storage_places = StoragePlace.all
    products = Product.all

    @total_amount_of_stock = Array.new

    products.each do |product|
      storage_places.each do |storage_place|
        products_in = InventoryMovement.where(storage_place: storage_place, product: product, movement_type: 'E').sum(:quantity)
        products_out = InventoryMovement.where(storage_place: storage_place, product: product, movement_type: 'S').sum(:quantity)

        @total_amount_of_stock.append(storage_place: storage_place.name, product: product.name, quantity: products_in - products_out)
      end
    end
  end


  def csv_file_import
    file_path = params[:file]
    movements_insertion_errors = Array.new

    if file_path.path.split('.').last.to_s.downcase != 'csv'
      redirect_to :root, :flash => { :error => "File must be CSV format" }
      return
    end

    headers = CSV.foreach(file_path).first

    valid_header = ["Nome do depósito", "Data", "Tipo de movimentação", "Nome do produto", "Quantidade do produto"]

    if valid_header.difference(headers).any?
      redirect_to :root, :flash => { :error => "File must be a valid header" }
      return
    end

    csv_rows = sort_csv_rows_by_date_and_movement_type(file_path)

    csv_rows.each do |row|
      result = import_row(row)

      if !result.save
        movements_insertion_errors << result.errors.full_messages
      end
    end

    respond_to do |format|
      format.html { redirect_to :root, notice: movements_insertion_errors }
    end
  end


  def sort_csv_rows_by_date_and_movement_type(csv_file_path)
    csv_rows = []

    CSV.foreach(csv_file_path.path, headers: true) do |row|
      csv_rows << row
    end

    csv_rows.sort! { |a,b| a.fetch("Data") <=> b.fetch("Data") }
    csv_rows.sort! { |a,b| a.fetch("Tipo de movimentação") <=> b.fetch("Tipo de movimentação") }
    
    return csv_rows
  end


  def import_row(row)
    product_name        = row.fetch("Nome do produto")
    storage_place_name  = row.fetch("Nome do depósito")
    movement_type       = row.fetch("Tipo de movimentação")
    date                = row.fetch("Data")
    quantity            = row.fetch("Quantidade do produto")

    if product_name.present? && storage_place_name.present?
      product = Product.where(name: product_name).first_or_create
      storage_place = StoragePlace.where(name: storage_place_name).first_or_create

      inventory_movement = InventoryMovement.new(product: product, 
                                                storage_place: storage_place, 
                                                date: Date.strptime(date, '%m/%d/%Y').strftime('%Y-%m-%d'), 
                                                movement_type: movement_type, 
                                                quantity: quantity)

      return inventory_movement
    end
  end

end