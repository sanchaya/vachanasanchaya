class CitationFormatter
  include ActionView::Helpers::DateHelper

  attr_reader :vachana

  SITE_NAME = "ವಚನ ಸಂಚಯ"
  SITE_URL = "https://vachana.sanchaya.net"

  def initialize(vachana)
    @vachana = vachana
  end

  def bibtex
    key = "vachana#{@vachana.vachanaid}"
    author = @vachana.vachanakaara.name
    title = "Vachana #{@vachana.vachanaid}"
    year = vachana_year
    url = "https://vachana.sanchaya.net/vachanas/#{@vachana.id}-#{@vachana.to_param}"

    %(@misc{#{key},
  author = {#{escape_bibtex(author)}},
  title  = {#{escape_bibtex(title)}},
  year   = {#{year}},
  note   = {#{escape_bibtex(SITE_NAME)}},
  url    = {#{escape_bibtex(url)}},
  urldate = #{Date.today.iso8601}
})
  end

  def vachana_year
    if @vachana.vachanakaara.try(:time_period).present?
      match = @vachana.vachanakaara.time_period.match(/\d{4}/)
      return match[0] if match
    end
    @vachana.created_at&.year || Date.today.year
  end

  private

  def escape_bibtex(text)
    text.to_s.gsub(/[{}\%&]/) { |m| "\\#{m}" }
  end
end