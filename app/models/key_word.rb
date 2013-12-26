class KeyWord < ActiveRecord::Base
attr_accessible :word, :count, :vachana_ids,:vachanakaara_ids
serialize :vachana_ids
serialize :vachanakaara_ids
   self.per_page = 20


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
      return @results, @vachanakaaras_word_count, @vachanakaaras_name
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

end
