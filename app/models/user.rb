class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :picks, dependent: :destroy
  has_many :pools
  has_many :pool_participants, dependent: :destroy

  validates :first_name, :last_name, presence: true

  def full_name
  	first_name + " " + last_name
  end

  def abbreviated_name
  	first_name[0] + " " + last_name
  end
end
