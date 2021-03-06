require 'spec_helper'

describe Curator do
  describe 'self.configure' do
    around(:each) do |example|
      old_config = Curator.config
      example.run
      Curator.instance_variable_set('@config', old_config)
    end

    it 'creates a configuration if one does not exist' do
      old_config = Curator.config
      Curator.instance_variable_set(:@config, nil)
      Curator.configure(:resettable_riak)
      Curator.config.should be_kind_of(Curator::Configuration)
    end

    it 'overwrites existing configuration in place' do
      Curator.configure(:resettable_riak) { |config| config.environment = "orig" }
      Curator.configure(:resettable_riak) { |config| config.environment = "new" }
      Curator.config.environment.should == "new"
    end

    it 'takes a block and passes the configuration' do
      block_config = nil
      Curator.configure(:resettable_riak) do |config|
        block_config = config
      end

      block_config.should_not be_nil
      block_config.should equal Curator.config
    end
  end
end
