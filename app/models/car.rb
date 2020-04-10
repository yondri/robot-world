class Car < ApplicationRecord
	# relations
	has_one :parts_defect, dependent: :destroy
  has_one :order, dependent: :destroy
  belongs_to :car_model

  accepts_nested_attributes_for :parts_defect, :allow_destroy => true

  # enumerators
  enum assembly_step: [:basic, :electronics, :details, :completed]
  enum status: [:initial, :in_factory, :in_store, :sold, :defective]

  # validations
  validates_presence_of :car_model, :year, :price, :cost_price, :assembly_step, :status

  # callbacks
  after_create :create_parts_defect

  def has_any_defect?
    parts_defect.wheels || parts_defect.chassis || parts_defect.laser || 
      parts_defect.computer || parts_defect.engine || parts_defect.seats
  end

  def defective_parts
    array = []
    ['wheels', 'chassis', 'laser', 'computer', 'engine', 'seats'].each do |part|
      array << part if parts_defect.send(part.to_sym)
    end

    array.join(', ')
  end

  private

end
