desc "Keywords count for each vachana"
task :update_keyword_count_in_vachana => :environment do
i = 1
	Vachana.find_each do |vachana|
		puts "Started"
		puts i
		words = vachana.vachana.split if vachana.vachana
		excluded_words = []
		hash = Hash.new
		words.each do |word|
          if excluded_words.include? word
          	hash[word] += 1 
          else
          	hash[word] = 1
          	excluded_words << word
          end
		end

		#creating keyword index 
		hash.each do |key, value|
			KeyWord.create(word: key, count: value, vachana_id: vachana.id)
		end
puts "keyword finished"
i += 1
	end
puts "mugithu"

	end