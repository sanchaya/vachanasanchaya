class Concord < ActiveRecord::Base
  attr_accessible :name, :parent_id, :concord_code, :count, :ids
  serialize :ids

  has_many :concord_items, dependent: :destroy

  def item_id_list
    concord_items.pluck(:item_id)
  end
end
