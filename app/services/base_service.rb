class BaseService
  attr_reader :errors, :valid

  def valid?
    @valid
  end

  private

  def set_as_invalid!
    @valid = false
  end

  def set_as_valid!
    @valid = true
  end

  def set_errors(errors)
    @errors = errors
  end

  def merge_errors(errors, prefix = nil)
    @errors = {}
    errors.each do |attr, error|
      error_key = prefix ? "#{prefix}_#{attr}" : "#{attr}"
      if error.is_a?(Array)
        error.each { |e| @errors[error_key] = error }
      else
        @errors[error_key] = error
      end
    end
  end

end