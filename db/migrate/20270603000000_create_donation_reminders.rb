class CreateDonationReminders < ActiveRecord::Migration
  def change
    create_table :donation_reminders do |t|
      t.string :email, null: false
      t.string :phone
      t.string :source, default: 'popup'
      t.timestamps
    end

    add_index :donation_reminders, :email
    add_index :donation_reminders, :created_at
  end
end
