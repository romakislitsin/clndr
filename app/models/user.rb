class User < ApplicationRecord
  has_many :events

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def can_edit?(event)
    event.user == self
  end

  def to_s
    self.fullname ? self.fullname : self.email
  end
end
