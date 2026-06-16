class KeyWord < ActiveRecord::Base
  attr_accessible :word, :count, :vachana_ids, :vachanakaara_ids
  serialize :vachana_ids
  serialize :vachanakaara_ids

  has_many :keyword_vachanas, dependent: :destroy
  has_many :keyword_vachanakaaras, dependent: :destroy
  has_many :linked_vachanas, through: :keyword_vachanas, source: :vachana
  has_many :linked_vachanakaaras, through: :keyword_vachanakaaras, source: :vachanakaara


  def self.search_vachana_pada(pada,type,author)

    @vachanakaaras_word_count =  []
    @vachanakaaras_name =  []
    add_search_count(pada, type)
    if type && type == "like_search"
      @results = where("word like ?", "%#{pada}%" )
     else
      @results = where(word: pada )
     end
@vachanas = @results.vachanas
unless author.blank?
  @vachanas = @vachanas.where(vachanakaara_id: author)
end
if author.blank?
  @total_counts = @results.sum(:count)
  @vachanakaaras = @vachanas.vachanakaaras
  counts = @vachanas.group(:vachanakaara_id).count
  @vachanakaaras.each do |vachanakaara|
    @vachanakaaras_word_count << counts[vachanakaara.id] || 0
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
     @total_counts += result.vachana_count_for(v_id)
   end
 end
end

return @vachanas, @vachanakaaras_word_count, @vachanakaaras_name,@total_counts 
end


def vachana_count_for(vachana_id)
  if keyword_vachanas.loaded? || keyword_vachanas.any?
    kwv = keyword_vachanas.detect { |kwv| kwv.vachana_id == vachana_id }
    kwv ? kwv.count : 0
  else
    keyword_vachanas.where(vachana_id: vachana_id).pluck(:count).first.to_i
  end
end

def all_vachana_ids
  keyword_vachanas.pluck(:vachana_id)
end

def vachanakaara_id_list
  keyword_vachanakaaras.pluck(:vachanakaara_id)
end

def vachana_id_count_hash
  Hash[keyword_vachanas.pluck(:vachana_id, :count)]
end


def self.vachanas
  vachana_ids = @results.flat_map(&:all_vachana_ids)
  Vachana.where(id: vachana_ids.uniq)
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
  path = File.new("#{Rails.root}/tmp/keywords.csv", "w")
  csv_string = CSV.open(path, "w") do |csv|
    csv << ["id", "word", "Vachanakaara"]
    vachanakaara_cache = {}
    KeyWord.find_each do |key|
      next if key.word.blank? || key.word == "\t" || key.word == "\n" || key.word == "`" || key.word == "``"
      key.vachanakaara_id_list.uniq.each do |va_id|
        vachanakaara = vachanakaara_cache[va_id] ||= Vachanakaara.find_by_id(va_id)
        csv << [key.id, key.word, vachanakaara.name] if vachanakaara
      end
    end
  end
end


end
