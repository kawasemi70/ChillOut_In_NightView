class Post < ApplicationRecord
  belongs_to :customer
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :spot, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  accepts_nested_attributes_for :spot
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  has_one_attached :spot_image

  validates :title, presence: true, length: {maximum: 50}
  validates :body, presence: true, length: {maximum: 250}
  with_options presence: true do
    validates :address
    validates :chillout
    validates :atmosphere
    validates :beautiful
    validates :access
    validates :congestion
    validates :evaluation

  end

  def get_spot_image(width, height)
    unless spot_image.attached?
      file_path = Rails.root.join('app/assets/images/NoImage.png')
      spot_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    spot_image.variant(resize_to_limit: [width, height]).processed
  end

  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end
  # # タグ作成
  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag_name: old)
    end

    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(tag_name: new)
      self.tags << new_post_tag
    end
  end

  # 検索方法分岐

  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @post = Post.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @post = Post.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @post = Post.where("title LIKE?","%#{word}%")
    else
      @post = Post.all
    end
  end
end
