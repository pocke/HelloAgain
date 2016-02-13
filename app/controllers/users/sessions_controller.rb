class Users::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super

    # Location をセーブ
    l = params.require(:user)[:location].split(',')
    lat = l[0]
    lng = l[1]

    current_user.location = {
      lat: lat,
      lng: lng,
    }
    current_user.save!

    # Event に追加
    ev = Event.first
    ev.user_ids.push(current_user.id)
    ev.user_ids.uniq!
    ev.save!
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
