require 'ostruct'
class Post < ApplicationRecord
  def self.states(post)
    states = [
      {
        state: :saved,
        into: %i[submitted_by_requester],
        conditions: [:not_implemented_yet]
      },
      {
        state: :returned_to_requester_by_decition_maker,
        into: %i[submitted_by_requester],
        conditions: [:not_implemented_yet]
      },

      # Decition_maker
      {
        state: :submitted_by_requester,
        into: %i[returned_to_requester_by_decition_maker recommended_for_approval_by_decition_maker recommended_for_rejection_by_decition_maker],
        conditions: [:not_implemented_yet]
      },
      {
        state: :returned_to_dicition_maker_by_admin,
        into: %i[returned_by_decition_maker recommended_for_approval_by_decition_maker recommended_for_rejection_by_decition_maker],
        conditions: [:not_implemented_yet]
      },

      # Admin
      { state: :recommended_for_approval_by_decition_maker,
        into: [:returned_to_dicition_maker_by_admin, :returned_to_requester_by_admin, :published],
        conditions: [:not_implemented_yet] 
      },
      { state: :recommended_for_rejection_by_decition_maker,
        into: [:returned_to_decition_maker_by_admin, :returned_to_requester_by_admin, :published],
        conditions: [:not_implemented_yet] 
      }
    ]

    # Find the correct state
    # byebug
    OpenStruct.new(states.select { |node| node[:state] == post.state.to_sym }.first)
  end
end
