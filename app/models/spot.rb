class Spot < ApplicationRecord
  belongs_to :post

# geocoded_byが入力した住所から緯度経度を保存。
# after_validation :geocodeは後に住所変更があっても、変更後の緯度経度を保存してくれる。
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
