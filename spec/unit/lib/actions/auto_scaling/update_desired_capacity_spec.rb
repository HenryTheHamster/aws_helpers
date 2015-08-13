require 'aws-sdk-core'

require 'aws_helpers/config'
require 'aws_helpers/actions/auto_scaling/update_desired_capacity'
require 'aws_helpers/actions/auto_scaling/poll_load_balancers_in_service_instances'

describe AwsHelpers::Actions::AutoScaling::UpdateDesiredCapacity do

  describe '#execute' do

    let(:auto_scaling_client) { instance_double(Aws::AutoScaling::Client) }
    let(:config) { instance_double(AwsHelpers::Config, aws_auto_scaling_client: auto_scaling_client) }

    let(:poll_in_service_instances) {instance_double(AwsHelpers::Actions::AutoScaling::PollInServiceInstances)}
    let(:poll_load_balancers_in_service_instances) { instance_double(AwsHelpers::Actions::AutoScaling::PollLoadBalancersInServiceInstances) }

    let(:auto_scaling_group_name) { 'name' }
    let(:desired_capacity) { 2 }

    before(:each) do
      allow(auto_scaling_client).to receive(:set_desired_capacity)
      allow(AwsHelpers::Actions::AutoScaling::PollInServiceInstances).to receive(:new).and_return(poll_in_service_instances)
      allow(poll_in_service_instances).to receive(:execute)
      allow(AwsHelpers::Actions::AutoScaling::PollLoadBalancersInServiceInstances).to receive(:new).and_return(poll_load_balancers_in_service_instances)
      allow(poll_load_balancers_in_service_instances).to receive(:execute)
    end

    after(:each) do
      AwsHelpers::Actions::AutoScaling::UpdateDesiredCapacity.new(config, auto_scaling_group_name, desired_capacity).execute
    end

    it 'should set the desired capacity' do
      expect(auto_scaling_client).to receive(:set_desired_capacity).with(auto_scaling_group_name: auto_scaling_group_name, desired_capacity: desired_capacity)
    end

    it 'should call PollHealthyInstances with correct parameters' do
      expect(AwsHelpers::Actions::AutoScaling::PollInServiceInstances).to receive(:new).with($stdout, config, auto_scaling_group_name)
    end

    it 'should call the execute method on PollInServiceInstances' do
      expect(poll_in_service_instances).to receive(:execute)
    end

    it 'should call PollLoadBalancersInServiceInstances with correct parameters' do
      expect(AwsHelpers::Actions::AutoScaling::PollLoadBalancersInServiceInstances).to receive(:new).with($stdout, config, auto_scaling_group_name)
    end

    it 'should call the execute method to PollLoadBalancersInServiceInstances' do
      expect(poll_load_balancers_in_service_instances).to receive(:execute)
    end

  end
end