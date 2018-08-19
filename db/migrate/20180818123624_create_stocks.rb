class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.integer :code
<<<<<<< HEAD
      t.string :name
=======
      t.string :company_name
>>>>>>> 4152801b53f89e3ab1043c7c074a154530b67809

      t.timestamps
    end
  end
end
