class GlossariesController < ApplicationController

  def index
    params[:start_letter] = params[:start_letter] || "ಅ"
    @words = Glossary.start_letter(params[:start_letter]).paginate(:page => params[:page], :per_page => 15)
    @glossary_letter_counts = Glossary.group("LEFT(word, 1)").count
    first_word = @words.first&.word
    if first_word.present?
      @vachanas = Vachana.where("vachana LIKE ?", "%#{first_word}%").limit(20)
    end
    set_meta_tags(
      title:       "ಪದಕೋಶ - ವಚನ ಸಂಚಯ",
      description: "ವಚನ ಸಾಹಿತ್ಯದಲ್ಲಿ ಬಳಕೆಯಾಗುವ ಪದಗಳ ಪದಕೋಶ. ವಚನ ಸಂಚಯದ ಪದಕೋಶವನ್ನು ಅನ್ವೇಷಿಸಿ.",
      keywords:    "ಪದಕೋಶ, ವಚನ ಪದಗಳು, ವಚನ ಸಂಚಯ, ಕನ್ನಡ ಸಾಹಿತ್ಯ"
    )
  end

  def search 
    @word = params[:word].to_s
    @words = Glossary.words_like(@word)
    @vachanas = Vachana.where("vachana LIKE ?", "%#{@word}%").limit(20)
    set_meta_tags(
      title:       "#{@word} - ಪದಕೋಶ ಹುಡುಕಾಟ - ವಚನ ಸಂಚಯ",
      description: "#{@word} ಪದಕ್ಕಾಗಿ ಪದಕೋಶ ಫಲಿತಾಂಶಗಳು.",
      keywords:    "#{@word}, ಪದಕೋಶ, ವಚನ ಸಂಚಯ"
    )
  end

end
