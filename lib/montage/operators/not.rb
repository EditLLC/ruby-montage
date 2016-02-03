module Montage
  module Operators
    class Not
      def self.operator
        "!="
      end

      def self.montage_operator
        "$not"
      end

      def self.==(value)
        value.include?("!=")
      end
    end
  end
end
