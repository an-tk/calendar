class Ability
  include CanCan::Ability

  def initialize(user)

      can :read, :all
      can :manage, Event, :user_id => user.id

  end
end
