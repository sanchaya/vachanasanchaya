module ApplicationHelper
	def vowels
		["ಅ", "ಆ", "ಇ", "ಈ", "ಉ" , "ಊ", "ಋ", "ೠ", "ಎ", "ಏ", "ಐ", "ಒ", "ಓ", "ಔ", "ಅಂ", "ಅಃ"]
	end

	def velars
		["ಕ", "ಖ", "ಗ", "ಘ", "ಙ"]
	end

	def palatals	 
		["ಚ", "ಛ", "ಜ", "ಝ", "ಞ"]
	end


	def retroflex 
		["ಟ", "ಠ", "ಡ", "ಢ", "ಣ"] 
	end

	def dentals 
		["ತ", "ಥ", "ದ", "ಧ", "ನ"]
	end

	def labials 
		["ಪ", "ಫ", "ಬ", "ಭ", "ಮ"]
	end

	def unstructured_consonants
		["ಯ", "ರ", "ಱ", "ಲ", "ವ", "ಶ", "ಷ", "ಸ", "ಹ", "ಳ"]
	end

	def get_roles
		if current_user.is_admin?
			Role.all
		else
			Role.where("name != ? ", 'Admin')
		end
	end


	def unselected_language
		I18n.locale.to_s == 'kn' ? 'en' : 'kn'
	end

	def select_unselected_language
		if I18n.locale.to_s == 'kn'
			'show in English'
		else
			'show in Kannada'
		end 
	end

end
