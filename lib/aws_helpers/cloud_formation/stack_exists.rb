module AwsHelpers

  module CloudFormation

    class StackExists

      # @param config [AwsHelpers::CloudFormation::Config] config object with access methods to aws_cloud_formation_client
      # @param stack_name [String] Stack name to search for

      def initialize(config, stack_name)

        @config = config
        @stack_name = stack_name

      end

      def execute

      end

    end

  end

end