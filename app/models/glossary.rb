class Glossary < ActiveRecord::Base
  attr_accessible :word,:meanings
  scope :start_letter, lambda {|letter| where("word like ? ", "#{letter}%" )}
end
