class ReferenceBook < ActiveRecord::Base
   attr_accessible :book_name, :book_volume, :publisher, :author, :published_year, :isbn, :language, :reference_type
end
