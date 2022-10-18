class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_one_attached :profile_image

  enum status: {nonreleased: 0, released: 1}

  validates :customername, uniqueness: true, length: {minimum: 2, maximum: 15}
  validates :introduction, length: {maximum: 100}

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/noimage.png')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end


  def self.guest
    find_or_create_by!(customername: 'guestuser', email: 'guest@example.com') do |customer|
      customer.password = SecureRandom.urlsafe_base64
      customer.customername = "guestuser"
    end
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("username LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("username LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("username LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("username LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

end