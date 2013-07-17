class Vachana < ActiveRecord::Base
  attr_accessible :author, :description, :name

  def self.search_vachana_pada(pada)
  vachanas=	where("description like ?", "%#{pada}%" )
  @results = {}
  vachanas.each do |vachana|
  	words = vachana.description.split
  	count = 0
	words.each do |word|
		count += 1 if word.upcase.include?(pada.upcase)
    end
    @results[vachana] = count
  end
  return @results
  end


end
