class Vachana < ActiveRecord::Base
  attr_accessible :author, :description, :name

  def self.search_vachana_pada(pada)

  	where("description like ?", pada)
  end
end
