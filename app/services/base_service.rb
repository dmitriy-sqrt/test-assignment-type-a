class BaseService
  class Result < Struct.new(:success, :errors)
    attr_reader :success, :errors, :object

    def initialize(success:, errors: [], object: nil)
      @success = success
      @errors  = errors
      @object  = object
    end
  end
end
