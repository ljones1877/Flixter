class Lesson < ApplicationRecord
  belongs_to :section
  mount_uploader :video, VideoUploader

  validates_presence_of :video
  validates_integrity_of :video
  validates_processing_of :video

  validates :title, presence: true
  validates :subtitle, presence: true
    

  include RankedModel
  ranks :row_order, with_same: :section_id

  def next_lesson
    lesson = section.lessons.where("row_order > ?", self.row_order).rank(:row_order).first
    if lesson.blank? && section.next_section
      return section.next_section.lessons.rank(:row_order).first
    end
    return lesson
  end

end