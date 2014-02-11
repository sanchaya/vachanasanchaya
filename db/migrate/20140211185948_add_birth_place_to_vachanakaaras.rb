class AddBirthPlaceToVachanakaaras < ActiveRecord::Migration
  def change
    add_column :vachanakaaras, :birth_place, :string
  end
end
