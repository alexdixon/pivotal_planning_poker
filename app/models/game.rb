class Game < ActiveRecord::Base
  serialize :estimates

  def self.create_or_update(tracker_story_id, tracker_estimate)
    if game = Game.first(:conditions => { :tracker_story_id => tracker_story_id })
      game.update_attribute(:tracker_estimate, tracker_estimate)
    else
      Game.create(:tracker_story_id => tracker_story_id, :tracker_estimate => tracker_estimate, :estimates => {})
    end
  end
end
