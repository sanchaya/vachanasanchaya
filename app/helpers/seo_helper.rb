# frozen_string_literal: true

module SeoHelper
  DEFAULT_TITLE       = "ವಚನ ಸಂಚಯ - ವಚನ ಸಾಹಿತ್ಯ ಸಂಶೋಧನೆ ಮತ್ತು ಅಧ್ಯಯನ ತಾಣ"
  DEFAULT_DESCRIPTION = "ವಚನ ಸಂಚಯವು ೨೫,೦೦೦ಕ್ಕೂ ಹೆಚ್ಚು ವಚನಗಳನ್ನು ಮತ್ತು ೨೫೦ಕ್ಕೂ ಹೆಚ್ಚು ವಚನಕಾರರನ್ನು ಒಳಗೊಂಡಿರುವ ಒಂದು ಉಚಿತ, ತೆರೆದ ಮೂಲ ಸಂಶೋಧನಾ ವೇದಿಕೆಯಾಗಿದೆ."
  DEFAULT_KEYWORDS    = "ವಚನ, ವಚನ ಸಾಹಿತ್ಯ, ಕನ್ನಡ ಸಾಹಿತ್ಯ, ವಚನಕಾರರು, ಬಸವಣ್ಣ, ಅಲ್ಲಮ ಪ್ರಭು, ಅಕ್ಕಮಹಾದೇವಿ, ಸಂಶೋಧನೆ, ಪದಪುಂಜ, ಕನ್ನಡ"
  SITE_NAME           = "ವಚನ ಸಂಚಯ"
  SITE_URL            = "https://vachana.sanchaya.net"

  def set_meta_tags(options = {})
    @meta_tags = {
      title:       options[:title]       || DEFAULT_TITLE,
      description: options[:description] || DEFAULT_DESCRIPTION,
      keywords:    options[:keywords]    || DEFAULT_KEYWORDS,
      canonical:   options[:canonical]   || request.original_url
    }
  end

  def meta_tags
    @meta_tags ||= {
      title:       DEFAULT_TITLE,
      description: DEFAULT_DESCRIPTION,
      keywords:    DEFAULT_KEYWORDS,
      canonical:   request.original_url
    }
  end

  def page_title
    meta_tags[:title]
  end

  def page_description
    meta_tags[:description]
  end

  def page_keywords
    meta_tags[:keywords]
  end

  def page_canonical
    meta_tags[:canonical]
  end

  def page_og
    {
      title:       page_title,
      description: page_description,
      url:         page_canonical,
      site_name:   SITE_NAME,
      locale:      "kn_IN",
      type:        "website"
    }
  end

  def page_twitter
    {
      card:        "summary",
      title:       page_title,
      description: page_description,
      site:        "@vachanasanchaya"
    }
  end

  # Build hreflang URL preserving pagination and letter params
  def hreflang_url(locale)
    base = request.original_url.split('?').first
    preserved = {}
    preserved[:start_letter] = params[:start_letter] if params[:start_letter].present?
    preserved[:page] = params[:page] if params[:page].present?
    
    if locale != I18n.locale.to_s
      preserved[:locale] = locale
    end
    
    if preserved.any?
      query = preserved.to_query
      "#{base}?#{query}"
    else
      base
    end
  end
end
