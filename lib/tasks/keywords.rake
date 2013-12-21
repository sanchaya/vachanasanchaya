desc "Keywords count for each vachana"
task :update_keyword_count_in_vachana => :environment do
		puts ">>>>>>>>>>>>>>Start >>>>>>>>>"
	i = 1
	Vachana.find_each do |vachana|
		puts i
		words = vachana.vachana.split if vachana.vachana
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
					keyword.update_attributes(count: total_count, vachana_ids: hash)
			    end
			else
				puts "new keyword"
				count = vachana.vachana.scan(word).count
				hash = {vachana.id => count}
				KeyWord.create(word: word , vachana_ids: hash, count: count)
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