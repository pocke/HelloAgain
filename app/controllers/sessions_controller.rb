class SessionsController < ApplicationController
  def sign_in
    p = params.require(:user).permit(:email, :password)
    email, password = p[:email], p[:password]
    user = User.find_by!(email: email)

    unless user.authenticate(password)
      raise UnauthorizedError, "認証に失敗しました。メールアドレスとパスワードを確認して下さい。"
    end

    session[:user_id] = user.id
    token = SecureRandom.hex(32)
    session[:csrf_token] = token

    meta = {
      status: true,
      csrf_token: token,
      message: 'ログインが完了しました',  # TODO: I18n
    }

    opt = render_option(user, status: 200)
    opt[:meta] = meta

    render opt
  end

  def sign_up
    p = params.require(:user).permit(:email, :password)
    email, password = p[:email], p[:password]

    if User.exists?(email: email)
      raise "User #{email} is exist"
    end

    u = User.new(email: email, password: password)
    u.save!
  end
end
