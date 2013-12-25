class Vachana < ActiveRecord::Base
  attr_accessible :author, :vachana, :name, :vachanakaara_id  , :vachanaid
  belongs_to :vachanakaara


  def self.search_vachana_pada(pada,type,author)
    # vachanas=	where("vachana like ?", "%#{pada}%" )
    @vachanakaaras_word_count =  []
    @vachanakaaras_name =  []
    @vachanakaaras_total_count =  []
    if type && type == "like_search"
      vachanas= where("vachana like ?", "%#{pada}%" )
    else
      # vachanas= where("vachana RLIKE ?","[[:<:]]#{pada}[[:>:]]" ) # exact search works with mysql
      vachanas= where("vachana like ?", "%#{pada} %" )
    end

    unless author.blank?
      vachanas = vachanas.where("vachanakaara_id = ?", "#{author}" )
    end
    add_search_count(pada, type)
    @results = {}
    vachanas.each do |vachana|
      words = vachana.vachana.split
      count = 0
      words.each do |word|
        count += 1 if word.upcase.include?(pada.upcase)
      end
      @results[vachana] = count
    end
    unless vachanas.blank?
      @vachanakaaras = vachanas.select("distinct(vachanakaara_id)")
      @vachanakaaras.each do |vachana|
        @vachanakaaras_word_count << vachanas.where("vachanakaara_id = #{vachana.vachanakaara_id}").count
       @vachanakaaras_total_count << vachana.vachanakaara.vachanas.count
        @vachanakaaras_name << '<span ><span  style="display:none">' + "#{vachana.vachanakaara.id}" + '</span>' + "#{vachana.vachanakaara.name}" + '</span>'

      end
    end
    return @results, @vachanakaaras_word_count, @vachanakaaras_name, @vachanakaaras_total_count, @vachanakaaras
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


def self.vachanakaara_ids
  includes(:vachanakaara).map(&:vachanakaara_id)
end

def self.vachanakaaras
  Vachanakaara.where(id: vachanakaara_ids)
end


scope :start_letter, lambda {|letter| where("vachana like ? ", "#{letter}%" ).limit(12)}

end
