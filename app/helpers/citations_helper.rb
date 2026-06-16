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
    key = "vachana#{vachana.vachanaid}"
    author = vachana.vachanakaara.name
    title = vachana_title(vachana)
    year = vachana_year(vachana)
    url = vachana_url(vachana)

    %(@misc{#{key},
  author = {#{author}},
  title  = {#{title}},
  year   = {#{year}},
  note   = {#{SITE_NAME}},
  url    = {#{url}},
  urldate = {#{Date.today.iso8601}}
})
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
end