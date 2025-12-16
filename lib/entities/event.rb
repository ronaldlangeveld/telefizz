module Entities
  class Event
    attr_reader :id, :action, :created_at, :eventable, :board, :creator

    def initialize(id:, action:, created_at:, eventable:, board:, creator:)
      @id = id
      @action = action
      @created_at = created_at
      @eventable = eventable
      @board = board
      @creator = creator
    end
  end
end