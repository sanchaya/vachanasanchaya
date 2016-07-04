class Vachana < ActiveRecord::Base
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user },
  :params => {
    used_ip: Proc.new{ |controller, model| controller.current_user.current_sign_in_ip }
  }
  
  attr_accessible :author, :vachana, :name, :vachanakaara_id, :vachanaid, :reviewed
  has_many :daily_vachanas
  belongs_to :vachanakaara
  has_one :old_vachana


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


scope :start_letter, lambda {|letter| where("vachana like ? ", "#{letter}%" )}



def self.vachanakaaras_vachana_concord(vachanakaara, start_letter)
  where("vachanakaara_id = ? and vachana like ? ", vachanakaara, "#{start_letter}%").count
end



# method to create zip
def self.download_all
  require 'zip'
  temp_file = Tempfile.new("filename")
  @vachanakaaras = Vachanakaara.includes(:vachanas)
  begin
  #This is the tricky part
  #Initialize the temp file as a zip file
  Zip::OutputStream.open(temp_file) { |zos| }
  #Add files to the zip file as usual
  Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
   @vachanakaaras.each do |vachanakaara|
    zip.get_output_stream("#{vachanakaara.reference_book ? vachanakaara.reference_book.id : ''}-#{vachanakaara.id}.txt") { |f| f.puts(vachanakaara.to_csv) }
  end
  zip.get_output_stream("reference-book.txt") { |f| f.puts(ReferenceBook.to_csv) }
  zip.get_output_stream("reference-vachanakaara.txt") { |f| f.puts(ReferenceBook.vachanakaara_to_csv) }
end
  #Read the binary data from the file
  @zip_data = File.read(temp_file.path)
  #Send the data to the browser as an attachment
  #We do not send the file directly because it will
  #get deleted before rails actually starts sending it
  # send_data(zip_data, :type => 'application/zip', :filename => filename)
end
return @zip_data
ensure
  #Close and delete the temp file
  temp_file.close
  temp_file.unlink
  # @vachanakaaras = Vachanakaara.includes(:vachanas).first(10)
  # Zip::File.open('def.zip', Zip::File::CREATE) do |zipfile|
  #   @vachanakaaras.each do |user|
  #     # zipfile.get_output_stream("#{user.name}.csv") { |f| f.puts(user.to_csv) }
  #   end
  # end
end


# searchable do
#   text :vachana
# end

end
