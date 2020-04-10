class Order < ApplicationRecord
	# relations
  belongs_to :car, optional: true
  belongs_to :car_model

  # enumerators
  enum status: [:initial, :completed, :returned, :incomplete]

  # validations
  validates_presence_of :car_model
end
