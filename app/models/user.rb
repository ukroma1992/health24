class User < ApplicationRecord
  has_many :commits, dependent: :destroy
end
