
require 'cru_lib/async'
require_relative 'async_commons'

require 'sidekiq/testing'
Sidekiq::Testing.inline!

# The class includes Sidekiq worker and responds properly to Async calls
#
class SidekiqAsync < ActiveRecordIsh
  include Sidekiq::Worker
  include CruLib::Async
end


describe CruLib::Async do
  describe 'when there is no id' do
    before(:each) do
      @tested = SidekiqAsync.new
    end

    it 'calls class method when one argument' do
      param_1 = SecureRandom.uuid

      # Expect class method get called with just one parameter
      #
      expect(SidekiqAsync).to receive(:method_1) do |arg_1, *arg_2|
        expect(arg_1).to eq(param_1)
        expect(arg_2.length).to eq(0)
      end

      @tested.async("method_1", param_1)
    end

    it 'calls class method when two arguments' do
      param_1 = SecureRandom.uuid
      param_2 = SecureRandom.uuid

      # Expect class method get called with two parameters
      #
      expect(SidekiqAsync).to receive(:method_2) do |arg_1, arg_2, *arg_3|
        expect(arg_1).to eq(param_1)
        expect(arg_2).to eq(param_2)
        expect(arg_3.length).to eq(0)
      end

      @tested.async("method_2", param_1, param_2)
    end
  end

  describe 'with id' do
    before(:each) do
      @tested = SidekiqAsync.new
      @id = SecureRandom.random_number(100_000)
      @tested.id = @id
    end

    it 'calls instance method properly when one argument' do
      param_1 = SecureRandom.uuid

      # Expect instance method get called with one parameter
      # The object's attribute id is properly set
      #
      expect_any_instance_of(SidekiqAsync).to receive(:inst_method_1) do |object, arg_1, *arg_2|
        expect(object.id).to eq(@id)
        expect(arg_1).to eq(param_1)
        expect(arg_2.length).to eq(0)
      end

      @tested.async("inst_method_1", param_1)
    end

    it 'calls instance method properly when two arguments' do
      param_1 = SecureRandom.uuid
      param_2 = SecureRandom.uuid

      # Expect instance method get called with two parameters
      # The object's attribute id is properly set
      #
      expect_any_instance_of(SidekiqAsync).to receive(:inst_method_2) do |object, arg_1, arg_2, *arg_3|
        expect(object.id).to eq(@id)
        expect(arg_1).to eq(param_1)
        expect(arg_2).to eq(param_2)
        expect(arg_3.length).to eq(0)
      end

      @tested.async("inst_method_2", param_1, param_2)
    end
  end
end