require 'rubygems'

require 'test/unit'

# gem 'activerecord'
require 'active_record'
require 'active_support'
require 'active_record/fixtures'

# Load the plugin like Rails will do it
require File.dirname(__FILE__) + '/../lib/active_record/acts/authenticatable'
require File.dirname(__FILE__) + '/../init'

# Establish Database Connection
ActiveRecord::Base.logger = Logger.new(STDOUT) if 'irb' == $0

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :dbfile => ':memory:')
ActiveRecord::Migration.verbose = false

ActiveRecord::Base.silence do
  ActiveRecord::Schema.define(:version => 1) do
    with_options :force => true do |m|
      m.create_table 'users' do |t|
        t.column :email, :string
        t.column :new_email, :string
        t.column :firstname, :string
        t.column :lastname, :string
        t.column :verified, :boolean
        t.column :salt, :string
        t.column :salted_password, :string
        t.column :security_token, :string
        t.column :token_expiry, :date
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
      end

      m.create_table 'accounts' do |t|
        t.column :email, :string
        t.column :new_email, :string
        t.column :account_number, :string
        t.column :firstname, :string
        t.column :lastname, :string
        t.column :verified, :boolean
        t.column :salt, :string
        t.column :salted_password, :string
        t.column :security_token, :string
        t.column :token_expiry, :date
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
      end
    end
  end
end

ActiveRecord::Base.configurations = { :logger => Logger.new(File.dirname(__FILE__) + "/log/test.log") }

# Load the test fixtures
Test::Unit::TestCase.fixture_path = File.dirname(__FILE__) + "/fixtures/"
$LOAD_PATH.unshift(Test::Unit::TestCase.fixture_path)

class Test::Unit::TestCase #:nodoc:
  def create_fixtures(*table_names)
    # puts "---- #{table_names.inspect}"
    if block_given?
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names) { yield }
    else
      Fixtures.create_fixtures(Test::Unit::TestCase.fixture_path, table_names)
    end
  end

  self.use_instantiated_fixtures  = false
  self.use_transactional_fixtures = true
end