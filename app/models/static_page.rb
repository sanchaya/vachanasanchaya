class StaticPage < ActiveRecord::Base
  attr_accessible :slug, :title, :body, :locale

  validates :slug, presence: true
  validates :locale, presence: true
  validates :slug, uniqueness: { scope: :locale }

  scope :by_locale, ->(locale) { where(locale: locale) }

  def self.content_for(slug, locale = I18n.locale.to_s)
    page = where(slug: slug, locale: locale).first
    page ? page.body : nil
  end
end