class ConcordItem < ActiveRecord::Base
  attr_accessible :concord_id, :item_id
  belongs_to :concord
end
