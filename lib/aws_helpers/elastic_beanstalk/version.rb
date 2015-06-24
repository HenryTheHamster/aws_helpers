require_relative 'application_version'
require_relative 'version_file'
require_relative 'version_zip_folder'


module AwsHelpers
  module ElasticBeanstalk
    class Version

      def initialize(elastic_beanstalk_client, s3_client, iam_client)
        @application_version = ApplicationVersion.new(elastic_beanstalk_client)
        @s3_client = s3_client
        @iam_client = iam_client
      end

      def upload(application, version, version_contents, zip_folder=false)
        raise_argument_error 'application' unless application
        raise_argument_error 'version' unless version
        raise_argument_error 'version_contents' unless version_contents

        klass = zip_folder ? AwsHelpers::ElasticBeanstalk::VersionZipFolder : VersionFile
        version_file = klass.new(@s3_client, @iam_client, application, version, version_contents)
        version_file.upload_to_s3
        @application_version.create(application, version_file)
      end

      def deploy(application, environment, version)
        raise_argument_error 'application' unless application
        raise_argument_error 'environment' unless environment
        raise_argument_error 'version' unless version

        @application_version.deploy(application, environment, version)
      end

      private

      def raise_argument_error(argument)
        fail ArgumentError, "#{argument} is not set"
      end

    end
  end
end