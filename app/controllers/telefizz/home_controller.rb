class Telefizz::HomeController < Telefizz::BaseController
  def index
    @recent_events = WebhookEvent.joins(:board)
                                  .where(boards: { user_id: Current.user.id })
                                  .recent
                                  .limit(10)
    @boards_count = Current.user.boards.count
    @events_count = WebhookEvent.joins(:board).where(boards: { user_id: Current.user.id }).count
  end
end
