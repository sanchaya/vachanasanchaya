class Concord < ActiveRecord::Base
  attr_accessible :name,:parent_id,:concord_code,:count,:vachanakaara_ids
  serialize :vachanakaara_ids
end
