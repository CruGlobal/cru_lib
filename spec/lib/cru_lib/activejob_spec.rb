require 'active_job'
require 'active_record'
require 'cru_lib/async'
require_relative 'async_commons'

ActiveJob::Base.queue_adapter = :inline

class ActiveJobTester < ActiveRecordIsh
  include CruLib::Async

  queue_as :default
end

class ActiveJobTester2 < ActiveRecordIsh
  include CruLib::Async

  queue_as :other_default
end

describe CruLib::Async do
  describe 'when there is no id' do
    before(:each) do
      @tested = ActiveJobTester.new
    end

    it 'calls class method when one argument' do
      param_1 = SecureRandom.uuid

      # Expect class method get called with just one parameter
      #
      expect(ActiveJobTester).to receive(:method_1) do |arg_1, *arg_2|
        expect(arg_1).to eq(param_1)
        expect(arg_2.length).to eq(0)
      end

      @tested.async(:method_1, param_1)
    end

    it 'calls class method when two arguments' do
      param_1 = SecureRandom.uuid
      param_2 = SecureRandom.uuid

      # Expect class method get called with two parameters
      #
      expect(ActiveJobTester).to receive(:method_2) do |arg_1, arg_2, *arg_3|
        expect(arg_1).to eq(param_1)
        expect(arg_2).to eq(param_2)
        expect(arg_3.length).to eq(0)
      end

      @tested.async(:method_2, param_1, param_2)
    end

    it 'two calls to different classes do not mess up anything' do
      param_1 = SecureRandom.uuid
      param_2 = SecureRandom.uuid
      param_3 = SecureRandom.uuid

      other_tested = ActiveJobTester2.new

      # Expect class method get called with two parameters
      #
      expect(ActiveJobTester).to receive(:method_one) do |arg_1, arg_2, *arg_3|
        expect(arg_1).to eq(param_1)
        expect(arg_2).to eq(param_2)
        expect(arg_3.length).to eq(0)
      end

      expect(ActiveJobTester2).to receive(:method_other) do |arg_1, *arg_2|
        expect(arg_1).to eq(param_3)
        expect(arg_2.length).to eq(0)
      end

      @tested.async(:method_one, param_1, param_2)
      other_tested.async(:method_other, param_3)
    end
  end

  describe 'with id' do
    before(:each) do
      @tested = ActiveJobTester.new
      @id = SecureRandom.random_number(100_000)
      @tested.id = @id
    end

    it 'calls instance method properly when one argument' do
      param_1 = SecureRandom.uuid

      # Expect instance method get called with one parameter
      # The object's attribute id is properly set
      #
      expect_any_instance_of(ActiveJobTester).to receive(:inst_method_1) do |object, arg_1, *arg_2|
        expect(object.id).to eq(@id)
        expect(arg_1).to eq(param_1)
        expect(arg_2.length).to eq(0)
      end

      @tested.async(:inst_method_1, param_1)
    end

    it 'calls instance method properly when two arguments' do
      param_1 = SecureRandom.uuid
      param_2 = {v1: SecureRandom.uuid, v2: SecureRandom.uuid}

      # Expect instance method get called with two parameters
      # The object's attribute id is properly set
      #
      expect_any_instance_of(ActiveJobTester).to receive(:sho_method_2) do |object, arg_1, arg_2, *arg_3|
        expect(object.id).to eq(@id)
        expect(arg_1).to eq(param_1)
        expect(arg_2).to eq(param_2)
        expect(arg_3.length).to eq(0)
      end

      @tested.async(:sho_method_2, param_1, param_2)
    end

    it 'two calls of two instance methods do not mess up anything' do
      param_1 = SecureRandom.uuid
      param_2 = {v1: SecureRandom.uuid, v2: SecureRandom.uuid}
      param_3 = SecureRandom.uuid

      other_tested = ActiveJobTester2.new
      other_id = SecureRandom.random_number(100_000)
      other_tested.id = other_id

      # Expect instance method get called with two parameters
      # The object's attribute id is properly set
      #
      expect_any_instance_of(ActiveJobTester).to receive(:sho_method_one) do |object, arg_1, arg_2, *arg_3|
        expect(object.id).to eq(@id)
        expect(arg_1).to eq(param_1)
        expect(arg_2).to eq(param_2)
        expect(arg_3.length).to eq(0)
      end

      expect_any_instance_of(ActiveJobTester2).to receive(:sho_method_other) do |object, arg_1, *arg_2|
        expect(object.id).to eq(other_id)
        expect(arg_1).to eq(param_3)
        expect(arg_2.length).to eq(0)
      end

      @tested.async(:sho_method_one, param_1, param_2)
      other_tested.async(:sho_method_other, param_3)
    end
  end
end