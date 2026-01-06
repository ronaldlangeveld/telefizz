class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
  end

  def create
    user = User.find_by(email_address: params[:email_address])

    if user
      user.send_magic_link!
    end

    # Always show the same message to prevent email enumeration
    redirect_to new_session_path, notice: "If an account exists with that email, you'll receive a sign-in link shortly."
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end
