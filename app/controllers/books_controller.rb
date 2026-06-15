class BooksController < ApplicationController
  def index
    @search_query = params[:search].to_s.strip
    @books = []

    if @search_query.present?
      require 'open-uri'
      require 'json'
      begin
        url = "https://archive.org/advancedsearch.php?q=#{URI.encode_www_form_component(@search_query)}+AND+collection:ServantsOfKnowledge&fl=identifier,title,creator,date,description,mediatype&rows=50&page=1&output=json"
        response = open(url, "User-Agent" => "VachanaSanchaya/1.0").read
        data = JSON.parse(response)
        @books = data["response"]["docs"] if data["response"]
      rescue => e
        @error = "ಪುಸ್ತಕಗಳನ್ನು ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ: #{e.message}"
      end
    end

    set_meta_tags(
      title:       "ವಚನ സംಬಂಧಿತ ಪುಸ್ತಕಗಳು - ವಚನ ಸಂಚಯ",
      description: "ಇಂಟರ್ನೆಟ್ ಆರ್ಕೈವ್‌ನ ಸರ್ವಂಟ್ಸ್ ಆಫ್ ನಾಲೆಡ್ಜ್ ಸಂಗ್ರಹದಲ್ಲಿ ಲಭ್ಯವಿರುವ ವಚನ ಸಾಹಿತ್ಯ ಪುಸ್ತಕಗಳನ್ನು ಹುಡುಕಿ ಮತ್ತು ವೀಕ್ಷಿಸಿ.",
      keywords:    "ವಚನ ಪುಸ್ತಕಗಳು, ಇಂಟರ್ನೆಟ್ ಆರ್ಕೈವ್, ವಚನ ಸಾಹಿತ್ಯ, ಕನ್ನಡ ಪುಸ್ತಕಗಳು, ವಚನಕಾರರು"
    )
  end
end