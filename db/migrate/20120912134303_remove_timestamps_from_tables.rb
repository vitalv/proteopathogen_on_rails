class RemoveTimestampsFromTables < ActiveRecord::Migration

  def change
    ActiveRecord::Base.connection.tables.each do |table|
      remove_timestamps table  unless table == "schema_migrations"
    end  
  end
  
end
