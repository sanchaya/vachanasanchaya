desc "concordance for vachanas"
task :update_concordance_for_vachanas => :environment do
		puts ">>>>>>>>>>>>>>Start >>>>>>>>>"
		alphabets = ["ಅ", "ಆ", "ಇ", "ಈ", "ಉ" , "ಊ", "ಋ", "ೠ", "ಎ", "ಏ", "ಐ", "ಒ", "ಓ", "ಔ", "ಅಂ", "ಅಃ"]  + ["ಕ", "ಖ", "ಗ", "ಘ", "ಙ"] + ["ಚ", "ಛ", "ಜ", "ಝ", "ಞ"] + ["ಟ", "ಠ", "ಡ", "ಢ", "ಣ"] + ["ತ", "ಥ", "ದ", "ಧ", "ನ"] + ["ಪ", "ಫ", "ಬ", "ಭ", "ಮ"] + ["ಯ", "ರ", "ಱ", "ಲ", "ವ", "ಶ", "ಷ", "ಸ", "ಹ", "ಳ"]
       parent = Concord.create(name: "vachana",concord_code: "vachana" )


       alphabets.each do |alphabet|
       	vachanas = Vachana.start_letter(alphabet)
       	count = vachanas.count
       	vachanakaara_ids = vachanas.pluck(:vachanakaara_id) 
       	Concord.create(name: alphabet,parent_id: parent.id, concord_code: "vachana_#{alphabet}", count: count, ids:  vachanakaara_ids)
       end
end





desc "concordance for keywords"
task :update_concordance_for_keywords => :environment do
		puts ">>>>>>>>>>>>>>Start >>>>>>>>>"
		alphabets = ["ಅ", "ಆ", "ಇ", "ಈ", "ಉ" , "ಊ", "ಋ", "ೠ", "ಎ", "ಏ", "ಐ", "ಒ", "ಓ", "ಔ", "ಅಂ", "ಅಃ"]  + ["ಕ", "ಖ", "ಗ", "ಘ", "ಙ"] + ["ಚ", "ಛ", "ಜ", "ಝ", "ಞ"] + ["ಟ", "ಠ", "ಡ", "ಢ", "ಣ"] + ["ತ", "ಥ", "ದ", "ಧ", "ನ"] + ["ಪ", "ಫ", "ಬ", "ಭ", "ಮ"] + ["ಯ", "ರ", "ಱ", "ಲ", "ವ", "ಶ", "ಷ", "ಸ", "ಹ", "ಳ"]
       parent = Concord.create(name: "key_word",concord_code: "key_word" )


       alphabets.each do |alphabet|
       	key_words= KeyWord.start_letter(alphabet)
       	count = key_words.count
       	vachanakaara_ids = key_words.pluck(:id) 
       	Concord.create(name: alphabet,parent_id: parent.id, concord_code: "key_word_#{alphabet}", count: count, ids:  vachanakaara_ids)
       end
end




desc "concordance for vachanakaara"
task :update_concordance_for_vachanakaara => :environment do
		puts ">>>>>>>>>>>>>>Start >>>>>>>>>"
		alphabets = ["ಅ", "ಆ", "ಇ", "ಈ", "ಉ" , "ಊ", "ಋ", "ೠ", "ಎ", "ಏ", "ಐ", "ಒ", "ಓ", "ಔ", "ಅಂ", "ಅಃ"]  + ["ಕ", "ಖ", "ಗ", "ಘ", "ಙ"] + ["ಚ", "ಛ", "ಜ", "ಝ", "ಞ"] + ["ಟ", "ಠ", "ಡ", "ಢ", "ಣ"] + ["ತ", "ಥ", "ದ", "ಧ", "ನ"] + ["ಪ", "ಫ", "ಬ", "ಭ", "ಮ"] + ["ಯ", "ರ", "ಱ", "ಲ", "ವ", "ಶ", "ಷ", "ಸ", "ಹ", "ಳ"]
       parent = Concord.create(name: "vachanakaara",concord_code: "vachanakaara" )


       alphabets.each do |alphabet|
       	vachanakaaras= Vachanakaara.start_letter(alphabet)
       	count = vachanakaaras.count
       	vachanakaara_ids = vachanakaaras.pluck(:id) 
       	Concord.create(name: alphabet,parent_id: parent.id, concord_code: "vachanakaara_#{alphabet}", count: count, ids:  vachanakaara_ids)
       end
end




desc "Keywords count for each vachana"
task :update_keyword_count_in_vachana => :environment do
		puts ">>>>>>>>>>>>>>Start >>>>>>>>>"
	i = 1
	Vachana.find_each do |vachana|
		puts i
		words = vachana.vachana.split(/\W+/) if vachana.vachana
		puts "inside vachana #{vachana.id}"
		words.each do |word|
			puts word
			puts "words loop"
			keyword = KeyWord.find_by_word(word)
			if keyword
				puts "already keyword exists "
				unless keyword.vachana_ids.keys.include?(vachana.id)
					puts "keyword in this vachana first time"
					count = vachana.vachana.scan(word).count
					total_count = keyword.count + count
	 				hash = keyword.vachana_ids
					hash[vachana.id] = count
					arraya = keyword.vachanakaara_ids
					arraya << vachana.vachanakaara_id
					keyword.update_attributes(count: total_count, vachana_ids: hash, vachanakaara_ids: arraya)
			    end
			else
				puts "new keyword"
				count = vachana.vachana.scan(word).count
				hash = {vachana.id => count}
				arraya = [vachana.vachanakaara_id]
				KeyWord.create(word: word , vachana_ids: hash, count: count, vachanakaara_ids: arraya)
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