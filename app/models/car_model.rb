class CarModel < ApplicationRecord
	has_many :cars, dependent: :destroy
end
