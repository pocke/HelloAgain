class User
	include Mongoid::Document
	include Mongoid::Geospatial
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
		:recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

	## Database authenticatable
	field :email,              type: String, default: ""
	field :encrypted_password, type: String, default: ""

	## Recoverable
	field :reset_password_token,   type: String
	field :reset_password_sent_at, type: Time

	## Rememberable
	field :remember_created_at, type: Time

	## Trackable
	field :sign_in_count,      type: Integer, default: 0
	field :current_sign_in_at, type: Time
	field :last_sign_in_at,    type: Time
	field :current_sign_in_ip, type: String
	field :last_sign_in_ip,    type: String

	# for Facebook
	field :name,     type: String
	field :affiliation,     type: String
	field :phone,     type: String
	field :image,     type: String
	field :uid,      type: String
	field :provider, type: String

	has_one :card

	field :location,  type: Point, spatial: true, delegate: true

	## Confirmable
	# field :confirmation_token,   type: String
	# field :confirmed_at,         type: Time
	# field :confirmation_sent_at, type: Time
	# field :unconfirmed_email,    type: String # Only if using reconfirmable

	## Lockable
	# field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
	# field :unlock_token,    type: String # Only if unlock strategy is :email or :both
	# field :locked_at,       type: Time
    def self.find_for_oauth(auth)
        user = User.where(uid: auth.uid, provider: auth.provider).first

        unless user
          binding.pry
            user = User.create(
                uid:      auth.uid,
                name:      auth.info.name,
                image: auth.info.image,
                provider: auth.provider,
                email:    User.dummy_email(auth),
                password: Devise.friendly_token[0, 20]
            )
        end

		user
	end

	private

	def self.dummy_email(auth)
		"#{auth.uid}-#{auth.provider}@example.com"
	end
end
