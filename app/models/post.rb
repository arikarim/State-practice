require 'ostruct'
class Post < ApplicationRecord
  
    def self.testing_condition_true!
      true
    end

    def self.testing_condition_false!
      false
    end
  def self.states(post)
    states = [
      {
        state: :saved,
        into: %i[submitted_by_requester],
        conditions: [:testing_condition_true]
      },
      #  Demonstration of conditions
      {
        state: :returned_to_requester_by_decition_maker,
        into: %i[submitted_by_requester],
        conditions: [:testing_condition_true]
      },
      {
        state: :returned_to_requester_by_decition_maker,
        into: %i[submitted_by_requester],
        conditions: [:testing_condition_false]
      },

      # Decition_maker
      {
        state: :submitted_by_requester,
        into: %i[returned_to_requester_by_decition_maker recommended_for_approval_by_decition_maker recommended_for_rejection_by_decition_maker],
        conditions: [:testing_condition_true]
      },
      {
        state: :returned_to_dicition_maker_by_admin,
        into: %i[returned_by_decition_maker recommended_for_approval_by_decition_maker recommended_for_rejection_by_decition_maker],
        conditions: [:testing_condition_true]
      },

      # Admin
      { state: :recommended_for_approval_by_decition_maker,
        into: [:returned_to_dicition_maker_by_admin, :returned_to_requester_by_admin, :published],
        conditions: [:testing_condition_true] 
      },
      { state: :recommended_for_rejection_by_decition_maker,
        into: [:returned_to_decition_maker_by_admin, :returned_to_requester_by_admin, :published],
        conditions: [:testing_condition_true] 
      }
    ]

    # # Find the correct state
    # byebug
    nodes = states.select { |node| node[:state] == post.state.to_sym }
    no = nodes.map { |e| OpenStruct.new(e) }
    # Ensure that only states whom conditions are met are returned
    no = no.select { |node| node.conditions.all? { |condition| self.send("#{condition.to_s}!") } == true }
    # Return the first result
    no.first
  end
end
