class SessionsController < ApplicationController
  def new
    
  end

  def sign_in
    p = params.require(:user).permit(:email, :password)
    email, password = p[:email], p[:password]
    user = User.find_by!(email: email)

    unless user.authenticate(password)
      raise UnauthorizedError, "認証に失敗しました。メールアドレスとパスワードを確認して下さい。"
    end

    session[:user_id] = user.id
  end

  def sign_up
    p = params.require(:user).permit(:email, :password)
    email, password = p[:email], p[:password]

    if User.exists?(email: email)
      raise "#{email} は既に存在します!"
    end

    u = User.new(email: email, password: password)
    u.save!
  end
end
