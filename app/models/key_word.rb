class KeyWord < ActiveRecord::Base
attr_accessible :word, :count, :vachana_id

   belongs_to :vachana
   self.per_page = 20


   def self.search_vachana_pada(pada,type,author)

   	@vachanakaaras_word_count =  []
    @vachanakaaras_name =  []

    if type && type == "like_search"

    	if author.blank?
          @results = where("word like ?", "%#{pada}%" )
       else
  	      @results = includes(:vachana).where("word like ? and vachanas.vachanakaara_id = ? ", "%#{pada}%", author )
       end

    else
    	 if author.blank?
           @results = where(word: pada )
       else
           @results = includes(:vachana).where("word = ? and vachanas.vachanakaara_id = ? ", pada, author)
       end
    end

@vachanakaaras = @results.vachanas.vachanakaaras
debugger
    @vachanakaaras.each do |vachanakaara|
        @vachanakaaras_word_count << @results.vachanas.where(vachanakaara_id: vachanakaara.id).count
        @vachanakaaras_name << '<span ><span  style="display:none">' + "#{vachanakaara.id}" + '</span>' + "#{vachanakaara.name}" + '</span>'
      end

      return @results, @vachanakaaras_word_count, @vachanakaaras_name
end


def self.vachana_ids
  includes(:vachana).map(&:vachana_id)
end

def self.vachanas
  Vachana.where(id: vachana_ids)
end

end
