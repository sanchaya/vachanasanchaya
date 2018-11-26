class Glossary < ActiveRecord::Base
  attr_accessible :word,:meanings

  scope :start_letter, lambda {|letter| where("word like ? ", "#{letter}%" )}

  scope :words_like, lambda {|word| where("word like ?", "%#{word}%").limit(50)} 
end
