require 'spec_helper'

module Cts
  module Mpx
    module Driver
      describe Exceptions do
        include_context "with parameters"

        let(:false_block) { proc { false } }
        let(:true_block) { proc { true } }
        let(:reference) { 1234 }

        describe "::raise_unless_account_id" do
          context "when the argument is not an account_id" do
            it "is expected to raise a ArgumentError with is not a valid account_id " do
              expect { described_class.raise_unless_account_id(reference) }.to raise_error ArgumentError, /#{reference} is not a valid account_id/
            end
          end

          it "is expected to return nil" do
            expect(described_class.raise_unless_account_id(account_id)).to be nil
          end
        end

        describe "::raise_unless_argument_error?" do
          it "is expected to raise an ArgumentError if the argument data is not of argument type's type." do
            expect { described_class.raise_unless_argument_error?([], String) }.to raise_error ArgumentError, /\[\] is not a valid String/
          end

          context "when a block is supplied" do
            it "is expected to yield to the block" do
              expect { |b| described_class.raise_unless_argument_error?("this is a string", String, &b) }.to yield_control.once
            end

            it "is expected to test the return of the block" do
              expect { described_class.raise_unless_argument_error?([], String) { false } } .not_to raise_error
            end
          end

          it "is expected to return nil" do
            expect(described_class.raise_unless_argument_error?("test", String)).to be nil
          end
        end

        describe "::raise_unless_reference?" do
          it { expect(described_class).to respond_to(:raise_unless_reference?).with(1).argument }
          context "when the argument is not a reference" do
            it "is expected to raise a ArgumentError with is not a valid reference " do
              expect { described_class.raise_unless_reference?(reference) }.to raise_error ArgumentError, /#{reference} is not a valid reference/
            end
          end

          it "is expected to return nil" do
            expect(described_class.raise_unless_reference?(account_id)).to be nil
          end
        end

        describe "::raise_unless_required_keyword?" do
          it "is expected to raise an error if required_keyword? returns false" do
            b = binding.dup
            b.local_variable_set(:arg, nil)
            expect { described_class.raise_unless_required_keyword? b, :arg }.to raise_error ArgumentError, /is a required keyword./
          end
        end
      end
    end
  end
end
