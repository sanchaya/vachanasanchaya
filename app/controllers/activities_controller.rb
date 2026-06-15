class ActivitiesController < ApplicationController
 before_filter :authenticate_user_role!
 # load_and_authorize_resource
 
 def index
  @activities = PublicActivity::Activity.order("created_at desc").limit(20)
  set_meta_tags(title: "ಚಟುವಟಿಕೆಗಳು - ವಚನ ಸಂಚಯ")
end
end
