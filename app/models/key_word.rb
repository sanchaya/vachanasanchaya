class KeyWord < ActiveRecord::Base
attr_accessible :word, :count, :vachana_id

   belongs_to :vachana

def self.vachana_ids
  includes(:vachana).map(&:vachana_id)
end

def self.vachanas
  Vachana.where(id: vachana_ids)
end

end
