class Telefizz::IntegrationsController < Telefizz::BaseController
  def index
    @telegram_integrations = Current.user.integrations.where(type: "TelegramIntegration")
    @slack_integrations = Current.user.integrations.where(type: "SlackIntegration")
  end

  # Telegram actions
  def new_telegram
    @integration = TelegramIntegration.new
  end

  def create_telegram
    @integration = TelegramIntegration.new(
      user: Current.user,
      name: telegram_params[:name],
      config: telegram_config
    )

    if @integration.save
      redirect_to telefizz_integrations_path, notice: "Telegram integration created successfully."
    else
      render :new_telegram, status: :unprocessable_entity
    end
  end

  def edit_telegram
    @integration = Current.user.integrations.find(params[:id])
  end

  def update_telegram
    @integration = Current.user.integrations.find(params[:id])
    @integration.name = telegram_params[:name]
    @integration.config = telegram_config

    if @integration.save
      redirect_to telefizz_integrations_path, notice: "Telegram integration updated successfully."
    else
      render :edit_telegram, status: :unprocessable_entity
    end
  end

  def destroy_telegram
    @integration = Current.user.integrations.find(params[:id])
    @integration.destroy
    redirect_to telefizz_integrations_path, notice: "Telegram integration removed."
  end

  # Slack actions
  def new_slack
    @integration = SlackIntegration.new
  end

  def create_slack
    @integration = SlackIntegration.new(
      user: Current.user,
      name: slack_params[:name],
      config: slack_config
    )

    if @integration.save
      redirect_to telefizz_integrations_path, notice: "Slack integration created successfully."
    else
      render :new_slack, status: :unprocessable_entity
    end
  end

  def edit_slack
    @integration = Current.user.integrations.find(params[:id])
  end

  def update_slack
    @integration = Current.user.integrations.find(params[:id])
    @integration.name = slack_params[:name]
    @integration.config = slack_config

    if @integration.save
      redirect_to telefizz_integrations_path, notice: "Slack integration updated successfully."
    else
      render :edit_slack, status: :unprocessable_entity
    end
  end

  def destroy_slack
    @integration = Current.user.integrations.find(params[:id])
    @integration.destroy
    redirect_to telefizz_integrations_path, notice: "Slack integration removed."
  end

  private

  def telegram_params
    params.require(:telegram_integration).permit(:name, :bot_token, :chat_id)
  end

  def telegram_config
    {
      "bot_token" => telegram_params[:bot_token],
      "chat_id" => telegram_params[:chat_id]
    }
  end

  def slack_params
    params.require(:slack_integration).permit(:name, :webhook_url)
  end

  def slack_config
    {
      "webhook_url" => slack_params[:webhook_url]
    }
  end
end
