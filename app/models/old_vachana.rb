class OldVachana < ActiveRecord::Base
 include PublicActivity::Model
 tracked owner: Proc.new{ |controller, model| controller.current_user },
 :params => {
  used_ip: Proc.new{ |controller, model| controller.current_user.current_sign_in_ip }
}

attr_protected

belongs_to :vachana
end
