# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user, params)
    user ||= User.new # guest user (not logged in)

    # nodes = [
    #   {state: :saved, into: [:submitted], children: ['b', 'c']},
    #   {state: :submitted, into: [:saved, :accepted], children: ['c']},
    #   {state: :accepted, into: [:submitted], children: []},
    # ]
    # {
    #   state: :submitted_by_requester,
    #   into: %i[returned_to_requester_by_decition_maker recommended_for_approval_by_decition_maker recommended_for_rejection_by_decition_maker],
    #   conditions: [:not_implemented_yet]
    # },

    post = Post.find(params[:id])
    # node = OpenStruct.new(nodes.select{|node| node[:state] == post.state.to_sym}.first)
    node = Post.states(post)

    can :update , Post, user_id: user.id, state: 'saved'
    if user.has_role?(:requester)
      can :read, Post, user_id: user.id, state: 'saved'
  
      states_can_be_seen_and_updated_by_requester = %i[saved returned_to_requester_by_decition_maker, returned_to_requester_by_admin]
      can %i[read update], Post if states_can_be_seen_by_requester.include?(post.state.to_sym)
    end

    if user.has_role?(:decition_maker)
      states_can_be_seen_and_updated_by_decition_maker = %i[submitted_by_requester returned_to_dicition_maker_by_admin]

      can %i[read update], Post if states_can_be_seen_and_updated_by_decition_maker.include?(post.state.to_sym)
    end

    if user.has_role?(:admin)
      states_can_be_seen_and_updated_by_admin = %i[recommended_for_approval_by_decition_maker recommended_for_rejection_by_decition_maker]

      can %i[read update], Post if states_can_be_seen_and_updated_by_admin.include?(post.state.to_sym)
    end
  end
end
