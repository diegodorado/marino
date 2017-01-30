
class Ability
  include CanCan::Ability

  def initialize(user)

    return unless user

    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.has_role? :admin or user.role? :admin #backward compatibily
      can :dashboard                  # allow access to dashboard
      can :manage, Company
      can :manage, Crop
      can :manage, CropControl
      can :manage, Invoice
      can :manage, Role
      can :manage, Store
      can :manage, User
    end


    if user.has_role? :crops
      can :manage, Crop
    end

    can :read, Company , :user_ids => user.id
    can :read, Company , :auditor_id => user.id
    can :read, Store , :company => {:user_ids => user.id}
    #can :update, Company , :user_ids => user.id
    #can :create, Store
    #can :manage, Store , :company => {:user_ids => user.id}
    can :manage, CropControl , :store_id => user.store_ids


  end
end
