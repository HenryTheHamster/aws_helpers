module AwsHelpers
  module Actions
    module RDS

      class SnapshotConstructName

        def initialize(config, db_instance_id)
          @config = config
          @db_instance_id = db_instance_id
        end

        def execute
          iam_client = @config.aws_iam_client
          region = iam_client.config.region
          iam_user_arn = iam_client.list_users.first.arn[/::(.*):/, 1]

          rds_client = @config.aws_rds_client
          tag_list = rds_client.list_tags_for_resource("arn:aws:rds:#{region}:#{iam_user_arn}:db:#{@db_instance_id}")

          name_tag = tag_list.detect { |tag| tag.key == 'Name' }
          name_tag.value
        end

      end

    end
  end
end