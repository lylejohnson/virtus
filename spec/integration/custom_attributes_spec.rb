require 'spec_helper'

describe 'custom attributes' do

  before do
    module Examples
      class NoisyString < Virtus::Attribute::String
        class UpperCase < Virtus::Attribute::Writer::Coercible
          def coerce(value)
            super.upcase
          end
        end

        lazy true

        def self.writer_class(*)
          UpperCase
        end
      end

      class RegularExpression < Virtus::Attribute::Object
        primitive Regexp
      end

      class User
        include Virtus

        attribute :name, String
        attribute :scream, NoisyString
        attribute :expression, RegularExpression
      end
    end
  end

  subject { Examples::User.new }

  specify 'allows you to define custom attributes' do
    regexp = /awesome/
    subject.expression = regexp
    subject.expression.should == regexp
  end

  specify 'allows you to define coercion methods' do
    subject.scream = 'welcome'
    subject.scream.should == 'WELCOME'
  end

end
