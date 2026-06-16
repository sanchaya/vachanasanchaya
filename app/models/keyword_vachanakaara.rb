class KeywordVachanakaara < ActiveRecord::Base
  attr_accessible :key_word_id, :vachanakaara_id
  belongs_to :key_word
  belongs_to :vachanakaara
end
