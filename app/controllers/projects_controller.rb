class ProjectsController < ApplicationController
  before_filter :detect_user

  def index
    @projects = @user.projects
  end

  def show
    @project = PivotalPlanningPoker::Project.find(params[:id], @user.token)
    @stories = PivotalPlanningPoker::Story.for_project(@project, @user.token)
  end

  def update_hand
    hand = CurrentHand.find_or_initialize_by_project_id(:project_id => params[:id])
    hand.story_id = params[:story_id]
    hand.save!
    head 200 
  end
end
