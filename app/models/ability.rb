class Ability
  include CanCan::Ability

  def initialize(user)
  
    user ||= User.new # guest user (not logged in)

    can :manage, :all if user.email == 'diegodorado@gmail.com'

    #can :manage, Backup , :creator_id => user.id
    can :manage, Message , :creator_id => user.id
    
    
    
  end
end
