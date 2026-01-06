class Telefizz::BoardController < Telefizz::BaseController
  def index
    @boards = Current.user.boards
  end

  def show
    @board = Current.user.boards.find(params[:id])
    @available_integrations = Current.user.integrations
  end

  def new
    @board = Current.user.boards.new
  end

  def create
    @board = Current.user.boards.new(board_params)
    if @board.save
      redirect_to telefizz_setup_board_path(@board), notice: "Board created! Now add the webhook to Fizzy."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def setup
    @board = Current.user.boards.find(params[:id])
  end

  def save_secret
    @board = Current.user.boards.find(params[:id])
    if @board.update(secret_params)
      redirect_to telefizz_show_board_path(@board), notice: "Board setup complete!"
    else
      render :setup, status: :unprocessable_entity
    end
  end

  def add_integration
    @board = Current.user.boards.find(params[:id])
    integration = Current.user.integrations.find(params[:integration_id])

    unless @board.integrations.include?(integration)
      @board.integrations << integration
    end

    redirect_to telefizz_show_board_path(@board), notice: "#{integration.class.name.underscore.humanize} connected!"
  end

  def remove_integration
    @board = Current.user.boards.find(params[:id])
    integration = Current.user.integrations.find(params[:integration_id])

    @board.integrations.delete(integration)

    redirect_to telefizz_show_board_path(@board), notice: "#{integration.class.name.underscore.humanize} disconnected."
  end

  private

  def board_params
    params.require(:board).permit(:name)
  end

  def secret_params
    params.require(:board).permit(:secret)
  end
end
