class KeywordVachana < ActiveRecord::Base
  attr_accessible :key_word_id, :vachana_id, :count
  belongs_to :key_word
  belongs_to :vachana
end
