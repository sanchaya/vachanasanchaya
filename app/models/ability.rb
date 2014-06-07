class Ability
  include CanCan::Ability

  def initialize(user,params)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
      if user.is_admin?
        can :manage, :all
    elsif user.role.name == "Admin"
        can :manage, User
    elsif user.role.name == "Publisher"
        can :manage, :publisher
        can :manage, User
    elsif user.role.name == "Reviewer"
        if (params[:user_id].to_i == user.id )
            can :read, ReviewVachana
            can :reviewed_vachanas, ReviewVachana
            if (params[:action] == "new" or params[:action] == "create" )
                vachana_id = params[:vachana_id] ? params[:vachana_id].to_i : params[:review_vachana][:vachana_id].to_i
                uv = user.vachanakaaras.map{|v| v.id}
                v = Vachana.find(vachana_id)
                if uv.include?(v.vachanakaara_id)
                    can :create, ReviewVachana
                end
            end

            if (params[:action] == "edit" or params[:action] == "update" )
                can :update, ReviewVachana if  ReviewVachana.find(params[:id]).reviewer_id == user.id
            end
        end
    else
        can :read, Vachana
    end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
end
end
