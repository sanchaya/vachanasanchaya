

desc "concordance for glossary"
task :update_concordance_for_glossary_priority_5 => :environment do
  puts ">>>>>>>>>>>>>>Start >>>>>>>>>"
  alphabets = ["ಅ", "ಆ", "ಇ", "ಈ", "ಉ" , "ಊ", "ಋ", "ೠ", "ಎ", "ಏ", "ಐ", "ಒ", "ಓ", "ಔ", "ಅಂ", "ಅಃ"]  + ["ಕ", "ಖ", "ಗ", "ಘ", "ಙ"] + ["ಚ", "ಛ", "ಜ", "ಝ", "ಞ"] + ["ಟ", "ಠ", "ಡ", "ಢ", "ಣ"] + ["ತ", "ಥ", "ದ", "ಧ", "ನ"] + ["ಪ", "ಫ", "ಬ", "ಭ", "ಮ"] + ["ಯ", "ರ", "ಱ", "ಲ", "ವ", "ಶ", "ಷ", "ಸ", "ಹ", "ಳ"]
  parent = Concord.create(name: "glossary",concord_code: "glossary" )


  alphabets.each do |alphabet|
    glossaries= Glossary.start_letter(alphabet)
    count = glossaries.count
    Concord.create(name: alphabet,parent_id: parent.id, concord_code: "glossary_#{alphabet}", count: count)
  end
end

desc "concordance for keywords"
task :update_concordance_for_keywords_priority_4 => :environment do
  puts ">>>>>>>>>>>>>>Start >>>>>>>>>"
  alphabets = ["ಅ", "ಆ", "ಇ", "ಈ", "ಉ" , "ಊ", "ಋ", "ೠ", "ಎ", "ಏ", "ಐ", "ಒ", "ಓ", "ಔ", "ಅಂ", "ಅಃ"]  + ["ಕ", "ಖ", "ಗ", "ಘ", "ಙ"] + ["ಚ", "ಛ", "ಜ", "ಝ", "ಞ"] + ["ಟ", "ಠ", "ಡ", "ಢ", "ಣ"] + ["ತ", "ಥ", "ದ", "ಧ", "ನ"] + ["ಪ", "ಫ", "ಬ", "ಭ", "ಮ"] + ["ಯ", "ರ", "ಱ", "ಲ", "ವ", "ಶ", "ಷ", "ಸ", "ಹ", "ಳ"]
  parent = Concord.create(name: "key_word",concord_code: "key_word" )

  alphabets.each do |alphabet|
    key_words = KeyWord.start_letter(alphabet)
    count = key_words.count
    concord = Concord.create(name: alphabet, parent_id: parent.id, concord_code: "key_word_#{alphabet}", count: count)
    key_words.pluck(:id).each_slice(1000) do |ids|
      inserts = ids.map { |id| "(#{concord.id}, #{id})" }.join(", ")
      ActiveRecord::Base.connection.execute("INSERT INTO concord_items (concord_id, item_id) VALUES #{inserts}")
    end
  end
end


desc "concordance for vachanas"
task :update_concordance_for_vachanas_priority_3 => :environment do
  puts ">>>>>>>>>>>>>>Start >>>>>>>>>"
  alphabets = ["ಅ", "ಆ", "ಇ", "ಈ", "ಉ" , "ಊ", "ಋ", "ೠ", "ಎ", "ಏ", "ಐ", "ಒ", "ಓ", "ಔ", "ಅಂ", "ಅಃ"]  + ["ಕ", "ಖ", "ಗ", "ಘ", "ಙ"] + ["ಚ", "ಛ", "ಜ", "ಝ", "ಞ"] + ["ಟ", "ಠ", "ಡ", "ಢ", "ಣ"] + ["ತ", "ಥ", "ದ", "ಧ", "ನ"] + ["ಪ", "ಫ", "ಬ", "ಭ", "ಮ"] + ["ಯ", "ರ", "ಱ", "ಲ", "ವ", "ಶ", "ಷ", "ಸ", "ಹ", "ಳ"]
  parent = Concord.create(name: "vachana",concord_code: "vachana" )

  alphabets.each do |alphabet|
    vachanas = Vachana.start_letter(alphabet)
    count = vachanas.count
    v_ids = vachanas.pluck(:vachanakaara_id)
    concord = Concord.create(name: alphabet, parent_id: parent.id, concord_code: "vachana_#{alphabet}", count: count)
    v_ids.each_slice(1000) do |ids|
      inserts = ids.map { |id| "(#{concord.id}, #{id})" }.join(", ")
      ActiveRecord::Base.connection.execute("INSERT INTO concord_items (concord_id, item_id) VALUES #{inserts}")
    end
  end
end


desc "concordance for vachanakaara"
task :update_concordance_for_vachanakaara_priority_2 => :environment do
  puts ">>>>>>>>>>>>>>Start >>>>>>>>>"
  alphabets = ["ಅ", "ಆ", "ಇ", "ಈ", "ಉ" , "ಊ", "ಋ", "ೠ", "ಎ", "ಏ", "ಐ", "ಒ", "ಓ", "ಔ", "ಅಂ", "ಅಃ"]  + ["ಕ", "ಖ", "ಗ", "ಘ", "ಙ"] + ["ಚ", "ಛ", "ಜ", "ಝ", "ಞ"] + ["ಟ", "ಠ", "ಡ", "ಢ", "ಣ"] + ["ತ", "ಥ", "ದ", "ಧ", "ನ"] + ["ಪ", "ಫ", "ಬ", "ಭ", "ಮ"] + ["ಯ", "ರ", "ಱ", "ಲ", "ವ", "ಶ", "ಷ", "ಸ", "ಹ", "ಳ"]
  parent = Concord.create(name: "vachanakaara",concord_code: "vachanakaara" )

  alphabets.each do |alphabet|
    vachanakaaras = Vachanakaara.start_letter(alphabet)
    count = vachanakaaras.count
    va_ids = vachanakaaras.pluck(:id)
    concord = Concord.create(name: alphabet, parent_id: parent.id, concord_code: "vachanakaara_#{alphabet}", count: count)
    va_ids.each_slice(1000) do |ids|
      inserts = ids.map { |id| "(#{concord.id}, #{id})" }.join(", ")
      ActiveRecord::Base.connection.execute("INSERT INTO concord_items (concord_id, item_id) VALUES #{inserts}")
    end
  end
end




desc "Keywords count for each vachana"
task :update_keyword_count_in_vachana_priority_1 => :environment do
  puts ">>>>>>>>>>>>>>Start >>>>>>>>>"
  i = 1
  Vachana.find_each do |vachana|
    puts i
    words = vachana.vachana.split(/\ |\,|\.|\;|(\n)/) if vachana.vachana
    puts "inside vachana #{vachana.id}"
    words.each do |word|
     puts word
     puts "words loop"
     keyword = KeyWord.find_by_word(word)
     if keyword
      puts "already keyword exists "
      unless keyword.keyword_vachanas.where(vachana_id: vachana.id).exists?
       puts "keyword in this vachana first time"
       count = words.count(word)
       total_count = keyword.count + count
       keyword.keyword_vachanas.create!(vachana_id: vachana.id, count: count)
       keyword.keyword_vachanakaaras.create!(vachanakaara_id: vachana.vachanakaara_id)
       keyword.update_attribute(:count, total_count)
     end
   else
    puts "new keyword"
    count = words.count(word)
    kw = KeyWord.create(word: word, count: count)
    kw.keyword_vachanas.create!(vachana_id: vachana.id, count: count)
    kw.keyword_vachanakaaras.create!(vachanakaara_id: vachana.vachanakaara_id)
   end
  end
  i += 1
 end
  puts ">>>>>>>>>>>finish >>>>>>>>>"
end






# desc "Keywords count for each vachana"
# task :update_keyword_count_in_vachana => :environment do
# i = 1
# 	Vachana.find_each do |vachana|
# 		puts "Started"
# 		puts i
# 		words = vachana.vachana.split if vachana.vachana
# 		excluded_words = []
# 		hash = Hash.new
# 		words.each do |word|
#           if excluded_words.include? word
#           	hash[word] += 1 
#           else
#           	hash[word] = 1
#           	excluded_words << word
#           end
# 		end

# 		#creating keyword index 
# 		hash.each do |key, value|
# 			KeyWord.create(word: key, count: value, vachana_id: vachana.id)
# 		end
# puts "keyword finished"
# i += 1
# 	end
# puts "mugithu"

# 	end