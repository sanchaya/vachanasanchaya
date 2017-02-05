class KeyWord < ActiveRecord::Base
  attr_accessible :word, :count, :vachana_ids,:vachanakaara_ids
  serialize :vachana_ids
  serialize :vachanakaara_ids
    # self.per_page = 50
  # WillPaginate.per_page = 20 #global set limit if in all model its same numbers


  def self.search_vachana_pada(pada,type,author)

    @vachanakaaras_word_count =  []
    @vachanakaaras_name =  []
    add_search_count(pada, type)
    if type && type == "like_search"

    	# if author.blank?
      @results = where("word like ?", "%#{pada}%" )
       # else
  	      # @results = where("word like ?  ", "%#{pada}%").select{|a| a.vachanakaara_ids.include?(author.to_i)}
       # end

     else
    	 # if author.blank?
      @results = where(word: pada )
       # else
           # @results = includes(:vachana).where("word = ? and vachanas.vachanakaara_id = ? ", pada, author)
       # end
     end
# @vachanakaaras = @results.vachanas.vachanakaaras
@vachanas = @results.vachanas
unless author.blank?
  @vachanas = @vachanas.where(vachanakaara_id: author)
end
if author.blank?
  @total_counts = @results.sum(:count)
  @vachanakaaras = @vachanas.vachanakaaras
  @vachanakaaras.each do |vachanakaara|
    @vachanakaaras_word_count << @vachanas.where(vachanakaara_id: vachanakaara.id).count
    @vachanakaaras_name << '<span ><span  style="display:none">' + "#{vachanakaara.id}" + '</span>' + "#{vachanakaara.name}" + '</span>'
  end
else
  vachanakaara = Vachanakaara.find(author)   
  @vachanakaaras_word_count << @vachanas.where(vachanakaara_id: vachanakaara.id).count
  @vachanakaaras_name << '<span ><span  style="display:none">' + "#{vachanakaara.id}" + '</span>' + "#{vachanakaara.name}" + '</span>'
  
end
if author.blank?
  @total_counts = @results.sum(:count)
else
  vachana_ids = @vachanas.pluck(:id)
  @total_counts = 0
  @results.each do |result|
   vachana_ids.each do |v_id|
     @total_counts += result.vachana_ids[v_id].to_i
   end
 end
end

return @vachanas, @vachanakaaras_word_count, @vachanakaaras_name,@total_counts 
end


# def self.vachana_ids

#   includes(:vachana).map(&:vachana_id)
# end

def self.vachanas
  vachana_ids = @results.map {|res| res.vachana_ids.keys}
  Vachana.where(id: vachana_ids)
end


def self.add_search_count(pada,type )
  @search_pada = WordList.find_by_name(pada)
  if @search_pada
    if type && type == "like_search"
      @search_pada.update_attribute('like_search_count', @search_pada.like_search_count + 1)
    else
      @search_pada.update_attribute('exact_search_count', @search_pada.exact_search_count + 1)
    end
  else
    @new_search = WordList.new(name: pada)
    if type && type == "like_search"
     @new_search.like_search_count = 1
   else
    @new_search.exact_search_count = 1
  end
  @new_search.save
end
end



scope :start_letter, lambda {|letter| where("word like ? ", "#{letter}%" )}


def self.to_csv
  CSV.generate do |csv|
    csv << ["id", "word"]
    all.each do |key|
      csv << [key.id, key.word]
    end
  end
end

def self.vachanakaara_keyword
 CSV.generate do |csv|
  csv << ["id", "word", "Vachanakaara"]
  all.each do |key|
    key.vachanakaara_ids.each do |vachanakaara|
      puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
      puts vachanakaara
      vachanakaara = Vachanakaara.find_by_id(vachanakaara)
      csv << [key.id, key.word, vachanakaara.name] if (vachanakaara && key.word !=  "\t" && key.word != "\n" && key.word != "" && key.word != "`" && key.word !=  "``")
    end
  end
end
end


end
