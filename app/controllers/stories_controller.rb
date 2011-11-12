class StoriesController < ApplicationController
  before_filter :detect_user
  before_filter :detect_project

  def show
    @story = PivotalPlanningPoker::Story.find(params[:project_id], params[:id], @user.token)
    Game.create_or_update(@story.story_id, @story.estimate)
  end

  def update
    tracker_story = PivotalPlanningPoker::Story.find(params[:project_id], params[:id], @user.token)
    tracker_story.update_estimate(params['estimate'], @user.token)

    Game.create_or_update(tracker_story.story_id, tracker_story.estimate)

    flash[:success] = "Story estimate updated"
    redirect_to project_story_path(@project.project_id, tracker_story.story_id)
  end
end
