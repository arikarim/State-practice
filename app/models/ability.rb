# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, params)
    # Define abilities for the passed in user here. For example:
    #
      user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    nodes = [
      {state: :saved, into: [:submitted], children: ['b', 'c']},
      {state: :submitted, into: [:saved, :accepted], children: ['c']},
      {state: :accepted, into: [:submitted], children: []},
    ]

    post = Post.find(params[:id])
    node = OpenStruct.new(nodes.select{|node| node[:state] == post.state.to_sym}.first)
    # byebug
    if user.has_role?(:admin) && node.into.include?(params[:post]['state'].to_sym)
      can :read, Post
      can :update , Post, user_id: user.id, state: 'saved'
      can :update , Post, state: 'submitted'
      can :update , Post, state: 'accepted'
    end
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
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
