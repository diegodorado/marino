
class Ability
  include CanCan::Ability

  def initialize(user)

    print user
    return unless user

    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, :to => :crud

    #can :read, :all                   # allow everyone to read everything

    if user.has_role? :admin or user.role? :admin #backward compatibily
      can :access, :rails_admin       # only allow admin users to access Rails Admin
      can :dashboard                  # allow access to dashboard
      can :manage, :all
      #if user.role? :superadmin
      #  can :manage, :all             # allow superadmins to do anything
      #elsif user.role? :manager
      #  can :manage, [User, Product]  # allow managers to do anything to products and users
      #elsif user.role? :sales
      #  can :update, Product, :hidden => false  # allow sales to only update visible products
      #end

    end

    if user.has_role? :backups
      can :manage, Backup
    end

    if user.has_role? :crops
      can :manage, Crop
    end

    can :create, Backup
    can [:read, :destroy], Backup , :creator_id => user.id
    can :update, Company , :user_ids => user.id
    can :create, Store
    can :manage, Store , :company => {:user_ids => user.id}
    can :manage, CropControl , :store_id => user.store_ids


  end
end
