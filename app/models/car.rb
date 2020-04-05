class Car < ApplicationRecord
	# relations
	has_one :parts_defect
  belongs_to :car_model

  # enumerators
  enum assembly_step: [:basic, :electronics, :details, :completed]
  enum status: [:initial, :in_factory, :in_store, :sold]

  # validations
  validates_presence_of :parts_defect, :car_model, :year, :price, :cost_price, :assembly_step, :status
end
