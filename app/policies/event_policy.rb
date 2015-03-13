class EventPolicy < ApplicationPolicy
  attr_reader :user, :event

  def initialize(user, event)
    @user = user
    @event = event
  end

  def update?
    user.has_role? :admin
    #current_user.has_role? :admin
  end
end