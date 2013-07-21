class Vachana < ActiveRecord::Base
  attr_accessible :author, :description, :name

  def self.search_vachana_pada(pada,type)
  # vachanas=	where("description like ?", "%#{pada}%" )
  if type && type == "like_search"
  vachanas= where("description like ?", "%#{pada}%" )
else
  vachanas= where("description RLIKE ?","[[:<:]]#{pada}[[:>:]]" )
end
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
