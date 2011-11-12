class CurrentHands < ActiveRecord::Migration
  def self.up
    create_table :current_hands do |t|
      t.integer :project_id, :null => false
      t.integer :story_id, :null => false
    end

	add_index :current_hands, :project_id, :unique => true
  end

  def self.down
    drop_table :current_hands
  end
end
