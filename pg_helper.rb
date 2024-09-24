require 'pg'
require 'colorize'

class PgHelper
  PG_USERNAME = 'postgres' # add pg username here
  PG_PASSWORD = '1234' # add pg password here

  attr_accessor :conn
  def initialize
    create_db
    @conn = PG.connect(password: PG_PASSWORD, user: PG_USERNAME, dbname: 'hangman_db')
    @winner_struct = Struct.new(:name, :score)

    create_winners_table
  end

  def self.create_connection
    new
  rescue => e
    puts "coudn't connect to db. ERROR: #{e}".blue
    return false
  end

  def winners(limit: 10)
    return @winners unless @winners.nil?

    winners_list = @conn.exec("select * from winners LIMIT #{limit}")
    fields = winners_list.fields
    @winners = winners_list.values.map do |winner|
      @winner_struct.new(
        winner[fields.find_index('name')],
        winner[fields.find_index('score')],
      )
    end
  end

  def create_winner(name, total_score)
    @conn.exec("insert into winners (Name, Score) VALUES ('#{name}', #{total_score})")
    @winners.push(@winner_struct.new(name, total_score))
  end

  private

  def create_db
    PG.connect(password: PG_PASSWORD, user: PG_USERNAME).exec('CREATE DATABASE hangman_db')
  rescue PG::DuplicateDatabase
    # do not raise error if db already exists
  end

  def create_winners_table
    @conn.exec('CREATE TABLE winners(Id serial NOT NULL, Name varchar(255), Score int, PRIMARY KEY (Id) )')
  rescue PG::DuplicateTable
    # # do not raise error if table already exists
  end
end