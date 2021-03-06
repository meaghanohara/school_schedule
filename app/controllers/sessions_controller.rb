class SessionsController < ApplicationController
  before_action :current_user_must_be_session_user, :only => [:show, :edit_form, :update_row, :destroy_row]

  def current_user_must_be_session_user
    session = Session.find(params["id_to_display"] || params["prefill_with_id"] || params["id_to_modify"] || params["id_to_remove"])

    unless current_user == session.user
      redirect_to :back, :alert => "You are not authorized for that."
    end
  end

  def index
    @q = current_user.sessions.ransack(params[:q])
    @sessions = @q.result(:distinct => true).includes(:user).page(params[:page]).per(10)

    render("session_templates/index.html.erb")
  end

  def show
    @session = Session.find(params.fetch("id_to_display"))

    render("session_templates/show.html.erb")
  end

  def new_form
    @session = Session.new

    render("session_templates/new_form.html.erb")
  end

  def create_row
    @session = Session.new

    @session.user_id = params.fetch("user_id")
    @session.starts_at = params.fetch("starts_at")
    @session.ends_at = params.fetch("ends_at")
    @session.message_sent = params.fetch("message_sent")
    @session.professor = params.fetch("professor")
    @session.location = params.fetch("location")

    if @session.valid?
      @session.save

      redirect_back(:fallback_location => "/sessions", :notice => "Session created successfully.")
    else
      render("session_templates/new_form_with_errors.html.erb")
    end
  end

  def edit_form
    @session = Session.find(params.fetch("prefill_with_id"))

    render("session_templates/edit_form.html.erb")
  end

  def update_row
    @session = Session.find(params.fetch("id_to_modify"))

    
    @session.starts_at = params.fetch("starts_at")
    @session.ends_at = params.fetch("ends_at")
    @session.message_sent = params.fetch("message_sent")
    @session.professor = params.fetch("professor")
    @session.location = params.fetch("location")

    if @session.valid?
      @session.save

      redirect_to("/sessions/#{@session.id}", :notice => "Session updated successfully.")
    else
      render("session_templates/edit_form_with_errors.html.erb")
    end
  end

  def destroy_row_from_user
    @session = Session.find(params.fetch("id_to_remove"))

    @session.destroy

    redirect_to("/users/#{@session.user_id}", notice: "Session deleted successfully.")
  end

  def destroy_row
    @session = Session.find(params.fetch("id_to_remove"))

    @session.destroy

    redirect_to("/sessions", :notice => "Session deleted successfully.")
  end
end
