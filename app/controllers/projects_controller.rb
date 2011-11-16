class ProjectsController < ApplicationController
  before_filter :detect_user

  def index
    @projects = @user.projects
  end

  def show
    @project = PivotalPlanningPoker::Project.find(params[:id], @user.token)
    @stories = PivotalPlanningPoker::Story.for_project(@project, @user.token, 'includedone:false')
  end

  def update_hand
    hand = CurrentHand.find_or_initialize_by_project_id(:project_id => params[:id])
    hand.story_id = params[:story_id]
    hand.save!
    head 200 
  end

  def current_hand
    @project = PivotalPlanningPoker::Project.find(params[:id], @user.token)
    @current_hand = CurrentHand.find_by_project_id(params[:id])
    @story = PivotalPlanningPoker::Story.find(params[:id], @current_hand.story_id, @user.token) unless @current_hand.nil?
    Game.create_or_update(@story.story_id, @story.estimate) unless @story.nil?
    if @story.nil?
      flash[:error] = 'No hand has been set'
      redirect_to :action => :show, :id => params[:id]
    else
      render '/stories/show'
    end
  end
end
