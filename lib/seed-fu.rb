require 'active_record'
require 'active_support/core_ext/module/attribute_accessors'
require 'seed-fu/railtie' if defined?(Rails) && Rails.version >= "3"

module SeedFu
  autoload :VERSION,               'seed-fu/version'
  autoload :Seeder,                'seed-fu/seeder'
  autoload :ActiveRecordExtension, 'seed-fu/active_record_extension'
  autoload :BlockHash,             'seed-fu/block_hash'
  autoload :Runner,                'seed-fu/runner'
  autoload :Writer,                'seed-fu/writer'

  mattr_accessor :quiet

  # Set `SeedFu.quiet = true` to silence all output
  @@quiet = false

  mattr_accessor :fixture_paths

  # Set this to be an array of paths to directories containing your seed files. If used as a Rails
  # plugin, SeedFu will set to to contain `Rails.root/db/fixtures` and
  # `Rails.root/db/fixtures/Rails.env`
  @@fixture_paths = ['db/fixtures']

  # Load seed data from files
  # @param [Array] fixture_paths The path/paths to look for seed files in
  # @param [Regexp] filter If given, only filenames matching this expression will be loaded
  def self.seed(fixture_paths_or_path = SeedFu.fixture_paths, filter = nil)
    if fixture_paths_or_path.is_a?(String) && File.file?(fixture_paths_or_path)
       Runner.new.run_file(fixture_paths_or_path)
    else
      Runner.new(fixture_paths_or_path, filter).run
    end
  end
end

# @public
class ActiveRecord::Base
  extend SeedFu::ActiveRecordExtension
end
