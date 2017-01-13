module RestApiClient
  class TypeCaster
    def initialize(value)
      @value = value
    end

    def value_to_primitive_type(type)
      case type.to_s
      when "Array"
        @value.to_a
      when "Hash"
        @value.to_h
      when "DateTime"
        case @value.class.name
        when "Time"
          @value.to_datetime
        when "DateTime"
          @value
        when "String"
          Time.parse(@value).to_datetime rescue raise @value.class.inspect
        else
          raise RestApiClient::UnknownTypeError.new("don't know primitive type: #{type}")
        end
      when "String"
        if @value.respond_to?(:to_s)
          @value.to_s
        else
          raise RestApiClient::TypeCastError.new("cant cast an instance of #{@value.class} to String")
        end
      when "Integer"
        if @value.respond_to?(:to_i)
          @value.to_i
        else
          raise RestApiClient::TypeCastError.new("cant cast an instance of #{@value.class} to Integer")
        end
      when "BigDecimal"
        to_big_decimal
      when "Boolean"
        to_boolean
      else
        raise RestApiClient::UnknownTypeError.new("don't know primitive type: #{type}")
      end
    end

    private

    def to_big_decimal
      return @value if @value.is_a?(BigDecimal)

      if @value.is_a?(String)
        BigDecimal.new(@value.gsub(/[^\d,\.]/, ''))
      elsif @value.is_a?(Integer)
        BigDecimal.new(@value.to_s)
      else
        raise RestApiClient::TypeCastError.new("can't cast #{@value} to a BigDecimal")
      end
    end

    def to_boolean
      return @value if @value.is_a?(TrueClass) || @value.is_a?(FalseClass)

      if [true, 1, "1", "true"].include?(@value)
        true
      elsif [false, 0, "0", "false"].include?(@value)
        false
      elsif @value.present?
        true
      elsif @value.blank?
        false
      else
        raise RestApiClient::TypeCastError.new("can't cast #{@value} to a Boolean")
      end
    end
  end
end
