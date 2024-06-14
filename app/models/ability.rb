class Ability
  include CanCan::Ability

  def initialize user
    can :read, Food

    return if user.blank?

    can [:read, :update], User, id: user.id
    can :add_to_cart, Food
    can [:read, :create, :update_status], Order

    return unless user.role.to_sym == :admin

    can :read, :all
    can [:create, :update, :destroy], Food
    can :update_status, Order
  end
end
