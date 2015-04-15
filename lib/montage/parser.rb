require 'montage/errors'
require 'json'

module Montage
  class Parser
    attr_reader :query, :operator, :column_name, :clause

  	OPERATOR_MAP = {
      "!=" => "__not",
			">=" => "__gte",
			"<=" => "__lte",
			"="  => "",
      ">"  => "__gt",
      "<"  => "__lt",
      "not in" => "__notin",
      "in" => "__in"
    }

  	def initialize(clause=nil)
  		if(clause)
  			@clause = clause
   			@column_name = get_column_name
   			@operator = get_operator
   			@query_parts = get_query_parts

   			@query = parse_string_clause
   		end
  	end

  	def get_column_name
  		@clause.downcase.split(' ')[0]
  	end

  	def get_operator
      OPERATOR_MAP.select { |key, value| @clause.downcase.include?(key) }
    end

  	def get_query_parts
  		query_parts = false
  		OPERATOR_MAP.each do |key, value|
			  if @clause.downcase.include? key
			  	query_parts = @clause.downcase.gsub(key, value)
			  	break
			  end
			end
			return false unless query_parts
			query_parts.split(' ')
  	end

  	def parse_query_value
  		value = @query_parts
      if is_i?(value)
        value[2].to_i
      elsif is_f?(value)
        value[2].to_f
      elsif @operator.keys[0] == 'not in' || @operator.keys[0] == 'in'
        value[2].gsub(/('|\(|\))/, "").split(',').map!{ |x| (is_i?(x) ? x.to_i : x) }
      elsif @operator.keys[0] == '='
      	if is_i?(value[1]) 
      		value[1].to_i
        else 
        	value[1].gsub(/('|\(|\))/, "")
        end
      else
      	if is_i?(value[2])
      		value[2].to_i
        else 
        	value[2].gsub(/('|\(|\))/, "")
        end
      end
    end

    def parse_value(value,operator)
      if is_i?(value)
        value.to_i
      elsif is_f?(value)
        value.to_f
      else
        if operator == 'in' || operator == 'not in'
          values = value.gsub(/('|\(|\))/, "").split(',').map!{ |x| (is_i?(x) ? x.to_i : x) }
        else
          value.gsub(/('|\(|\))/, "")
        end

      end
    end


  	def parse_string_clause

			raise QueryError, "Your query has an undetermined error" unless @query_parts
      raise QueryError, "The operator you have used is not a valid Montage query operator" unless @operator.keys[0]

      value = parse_query_value

      { "#{@query_parts[0]}#{@operator.values[0]}".to_sym => value }
    end

    def is_i?(value)
      /\A\d+\z/ === value
    end

    # Determines if the string value passed in is a float
    # Returns true or false
    #
    def is_f?(value)
      /\A\d+\.\d+\z/ === value
    end
  end
end
