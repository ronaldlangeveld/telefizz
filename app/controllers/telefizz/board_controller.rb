class Telefizz::BoardController < Telefizz::BaseController
  def index
    @boards = Current.user.boards
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
      redirect_to telefizz_board_path, notice: "Board setup complete!"
    else
      render :setup, status: :unprocessable_entity
    end
  end

  private

  def board_params
    params.require(:board).permit(:name)
  end

  def secret_params
    params.require(:board).permit(:secret)
  end
end
