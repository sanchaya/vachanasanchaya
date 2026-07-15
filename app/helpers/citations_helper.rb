module CitationsHelper
  SITE_NAME = "ವಚನ ಸಂಚಯ"
  SITE_URL = "https://vachana.sanchaya.net"

  def citation_mla(vachana)
    author = vachana.vachanakaara.name
    title = vachana_title(vachana)
    "#{author}. \"#{title}.\" *#{SITE_NAME}*, #{access_date}, #{vachana_url(vachana)}."
  end

  def citation_apa(vachana)
    author = vachana.vachanakaara.name
    title = vachana_title(vachana)
    year = vachana_year(vachana)
    "#{author} (#{year}). #{title}. *#{SITE_NAME}*. #{vachana_url(vachana)}"
  end

  def citation_chicago(vachana)
    author = vachana.vachanakaara.name
    title = vachana_title(vachana)
    "#{author}. \"#{title}.\" *#{SITE_NAME}*. #{access_date}. #{vachana_url(vachana)}."
  end

  def citation_bibtex(vachana)
    CitationFormatter.new(vachana).bibtex
  end

  def vachana_title(vachana)
    "Vachana #{vachana.vachanaid}"
  end

  def vachana_year(vachana)
    if vachana.vachanakaara.try(:time_period).present?
      match = vachana.vachanakaara.time_period.match(/\d{4}/)
      return match[0] if match
    end
    vachana.created_at&.year || Date.today.year
  end

  def access_date
    Date.today.strftime("%d %b %Y")
  end

  def vachana_url(vachana)
    "https://vachana.sanchaya.net/vachanas/#{vachana.id}-#{vachana.to_param}"
  end
end