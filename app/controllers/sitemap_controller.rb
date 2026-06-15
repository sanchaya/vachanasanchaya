class SitemapController < ApplicationController
  layout false

  def index
    @urls = []

    # Static pages
    @urls << { loc: root_url, lastmod: Date.today, changefreq: 'daily', priority: '1.0' }
    @urls << { loc: about_us_url, lastmod: Date.today, changefreq: 'monthly', priority: '0.7' }
    @urls << { loc: contact_us_url, lastmod: Date.today, changefreq: 'monthly', priority: '0.7' }
    @urls << { loc: help_url, lastmod: Date.today, changefreq: 'monthly', priority: '0.7' }
    @urls << { loc: about_us_url(locale: 'en'), lastmod: Date.today, changefreq: 'monthly', priority: '0.6' }

    # Vachanakaara index pages (alphabet navigation)
    all_letters = vowels + velars + palatals + retroflex + dentals + labials + unstructured_consonants
    all_letters.each do |letter|
      @urls << { loc: vachanakaaras_url(start_letter: letter), lastmod: Date.today, changefreq: 'weekly', priority: '0.7' }
    end

    # Vachana concord pages (alphabet navigation)
    all_letters.each do |letter|
      @urls << { loc: vachanas_vachana_concord_url(start_letter: letter), lastmod: Date.today, changefreq: 'weekly', priority: '0.7' }
    end

    # Research/keyword pages (alphabet navigation)
    all_letters.each do |letter|
      @urls << { loc: researches_url(start_letter: letter), lastmod: Date.today, changefreq: 'weekly', priority: '0.6' }
    end

    # Individual vachanakaara pages (batched for memory efficiency)
    Vachanakaara.pluck(:id, :updated_at).each do |id, updated_at|
      @urls << { loc: vachanakaara_url(id), lastmod: updated_at || Date.today, changefreq: 'weekly', priority: '0.8' }
    end

    # Individual vachana pages (batched for memory efficiency)
    Vachana.pluck(:id, :updated_at).each do |id, updated_at|
      @urls << { loc: vachana_url(id), lastmod: updated_at || Date.today, changefreq: 'monthly', priority: '0.6' }
    end

    # Glossary pages
    Glossary.pluck(:id).each do |id|
      @urls << { loc: glossary_url(id), lastmod: Date.today, changefreq: 'monthly', priority: '0.5' }
    end

    respond_to do |format|
      format.xml
    end
  end
end
