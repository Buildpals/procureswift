# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :set_cart, only: %i[show edit update destroy]

  # GET /carts/1
  # GET /carts/1.json
  def show; end
end
