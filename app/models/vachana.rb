class Vachana < ActiveRecord::Base
  attr_accessible :author, :vachana, :name

  def self.search_vachana_pada(pada,type)
  # vachanas=	where("vachana like ?", "%#{pada}%" )
  if type && type == "like_search"
  vachanas= where("vachana like ?", "%#{pada}%" )
else
  # vachanas= where("vachana RLIKE ?","[[:<:]]#{pada}[[:>:]]" ) # exact search works with mysql
  vachanas= where("vachana like ?", "%#{pada} %" )
end
  @results = {}
  vachanas.each do |vachana|
  	words = vachana.vachana.split
  	count = 0
	words.each do |word|
		count += 1 if word.upcase.include?(pada.upcase)
    end
    @results[vachana] = count
  end
  return @results
  end


end
