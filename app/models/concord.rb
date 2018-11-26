class Concord < ActiveRecord::Base
  attr_accessible :name,:parent_id,:concord_code,:count,:ids
  serialize :ids
end
