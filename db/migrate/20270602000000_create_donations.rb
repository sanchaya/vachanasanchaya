class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.string :donor_name
      t.string :donor_email
      t.string :payment_id
      t.string :razorpay_order_id
      t.decimal :amount, precision: 10, scale: 2
      t.string :currency, default: 'INR'
      t.string :status, default: 'pending'
      t.text :notes
      t.datetime :paid_at
      t.timestamps
    end

    add_index :donations, :payment_id
    add_index :donations, :razorpay_order_id
    add_index :donations, :status
    add_index :donations, :paid_at
  end
end
