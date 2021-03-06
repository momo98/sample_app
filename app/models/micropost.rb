class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  mount_uploader :picture, PictureUploader
  validate :picture_size
  
  private
  
    def picture_size
      if picture.size > 5.megabytes
        error.add(:picture, "should be less than 5mb")
      end
    end

end
