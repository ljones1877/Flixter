class Instructor::LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_authorized_for_current_lesson, only: [:show]

  def show
  end
  
  private

  def require_user_be_enrolled
    if !current_user.enrolled_in?(current_lesson.section.course)
        redirect_to course_path(current_lesson.section.course), alert: 'You must be enrolled in this course before you can view its lessons.'
    end
  end
  
  def require_authorized_for_current_section
    if current_section.course.user != current_user
      render plain: 'Unauthorized', status: :unauthorized
    end
  end

  helper_method :current_lesson
  def current_lesson
    @current_lesson ||= Lesson.find(params[:section_id])
  end

  def lesson_params
    params.require(:lesson).permit(:title, :subtitle, :video)
  end
end
