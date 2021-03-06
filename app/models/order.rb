# == Schema Information
#
# Table name: orders
#
#  id                   :integer          not null, primary key
#  title                :string
#  description          :text
#  preference_type      :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  aasm_state           :string
#  user_id              :integer
#  current_stage_id     :integer
#  image                :string
#  style_and_regulation :text
#  price                :float
#  deadline             :datetime
#  designer_id          :integer
#

class Order < ApplicationRecord
	mount_uploader :image, ImageUploader

	has_many :stages
	belongs_to :user
  accepts_nested_attributes_for :stages, :allow_destroy => true

  scope :available_for, -> (user){ where("(designer_id is null AND aasm_state != 'placed') OR designer_id = ?", user.id) }

  include AASM

  aasm do
  	state :placed, :initial => true
    state :paid
    state :picked
  	state :versions_submitted
  	state :version_selected
  	state :completed

    event :pay do
      transitions :from => :placed, :to => :paid
    end

    event :pick do
      transitions :paid => :placed, :to => :picked
    end

  	event :submit_initial_versions do
      transitions :from => :picked, :to => :versions_submitted
    end

    event :select_version do
      transitions :from => :versions_submitted, :to => :version_selected
    end

    event :submit_new_versions do
      transitions :from => :version_selected, :to => :versions_submitted
    end

    event :complete do
      transitions :from => :versions_submitted, :to => :completed
    end
  end

  def current_stage
    stage = Stage.find_by(id: self.current_stage_id)
    if stage.blank?
      stage = new_stage
    end
    stage
  end

  def state_cn
    case self.aasm_state
    when "placed"
      return "已下单"
    when "paid"
      return "已付款"
    when "picked"
      return "已接单" 
    when "versions_submitted"
      return "已提交"
    when "version_selected"
      return "已确认"
    when "completed"
      return "已完成"
    end
  end

  def new_stage
    stage = self.stages.build
    stage.save
    self.current_stage_id = stage.id
    self.save
    stage
  end

  def created_time
    
  end

  def set_current_stage(stage)
    self.current_stage_id = stage.id
    self.save
  end

  def last_selected_version
    Version.where(stage: self.stages.ids).where(aasm_state: "selected").last
  end

  def designer
    User.find_by(id:self.designer_id)
  end

  def set_designer?(designer)
    if self.designer_id.blank? && self.may_pick?
      self.update_columns(designer_id: designer.id)
      self.pick!
      true
    else
      false
    end
  end

end
