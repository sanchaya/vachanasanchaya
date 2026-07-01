class ResearchesController < ApplicationController
	def index
		params[:start_letter] = params[:start_letter] ? params[:start_letter] : "ಅ"
   		@keywords = KeyWord.start_letter(params[:start_letter]).order("count DESC").paginate(:page => params[:page], :per_page => 100)
  		set_meta_tags(
  		  title:       "#{params[:start_letter]} ಪದದಿಂದ ಪ್ರಾರಂಭವಾಗುವ ಪದಪುಂಜಗಳು - ಸಂಶೋಧನೆ - ವಚನ ಸಂಚಯ",
  		  description: "#{params[:start_letter]} ಅಕ್ಷರದಿಂದ ಪ್ರಾರಂಭವಾಗುವ ಪದಪುಂಜಗಳ ಪಟ್ಟಿ. ವಚನ ಸಂಚಯದ ಸಂಶೋಧನಾ ಸಾಧನಗಳನ್ನು ಬಳಸಿ ವಚನ ಸಾಹಿತ್ಯವನ್ನು ಅಧ್ಯಯನ ಮಾಡಿ.",
  		  keywords:    "#{params[:start_letter]}, ಪದಪುಂಜ, ಸಂಶೋಧನೆ, ವಚನ ಸಂಚಯ, ಕನ್ನಡ ಸಾಹಿತ್ಯ"
  		)
  	respond_to do |format|
  		format.html
  format.js # actually means: if the client ask for js -> return file.js
end
	end

  def show
    @keyword = KeyWord.find_by_word(params[:id])
    if @keyword.nil?
      @keyword = KeyWord.find(params[:id])
    end
    
    @vachanas = Vachana.where(id: @keyword.all_vachana_ids)
    @vachanakaaras = Vachanakaara.where(id: @keyword.vachanakaara_id_list).order(:name)
    
    set_meta_tags(
      title:       "#{@keyword.word} - ಪದಪುಂಜ - ವಚನ ಸಂಚಯ",
      description: "#{@keyword.word} ಪದವು #{@keyword.keyword_vachanas.count} ವಚನಗಳಲ್ಲಿ #{@vachanakaaras.count} ವಚನಕಾರರಿಂದ ಬಳಕೆಯಾಗಿದೆ. ವಚನ ಸಂಚಯದಲ್ಲಿ ಈ ಪದದ ಬಳಕೆಯನ್ನು ಅಧ್ಯಯನ ಮಾಡಿ.",
      keywords:    "#{@keyword.word}, ಪದಪುಂಜ, ಸಂಶೋಧನೆ, ವಚನ ಸಂಚಯ, ಕನ್ನಡ ಸಾಹಿತ್ಯ"
    )
  end
end
