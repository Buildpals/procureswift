# frozen_string_literal: true

class AdminController < ApplicationController
  before_action :authorized?

  private

  def authorized?
    unless current_user.admin?
      redirect_to root_path, notice: 'You are not authorized to view that page.'
    end
  end
end
