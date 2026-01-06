class SessionMailer < ApplicationMailer
  def magic_link(user)
    @user = user
    @magic_link_url = magic_link_url(token: user.login_token)

    mail subject: "Sign in to #{Rails.application.class.module_parent_name}", to: user.email_address
  end
end
