class CarModel < ApplicationRecord
	has_many :cars, dependent: :destroy
	has_many :orders, dependent: :destroy
end
