class MagicLinksController < ApplicationController
  allow_unauthenticated_access only: %i[show]
  rate_limit to: 10, within: 3.minutes, only: :show, with: -> { redirect_to new_session_path, alert: "Too many attempts. Try again later." }

  def show
    user = User.find_by_login_token(params[:token])

    if user
      user.clear_login_token!
      start_new_session_for user
      redirect_to after_authentication_url, notice: "You have been signed in successfully."
    else
      redirect_to new_session_path, alert: "Invalid or expired sign-in link. Please request a new one."
    end
  end
end
