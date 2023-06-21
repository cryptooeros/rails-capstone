class Api::V1::CarsController < Api::V1::BaseController
  before_action :set_car, only: %i[show destroy]

  def index
    cars = Car.all.order(created_at: :desc)
    render json: cars.as_json(include: :image)

  end

  def create
    car = Car.create!(car_params)
    car.user = current_user
    if car
      render json: car
    else
      render json: car.errors
    end
  end

  def show
    render json: @car.as_json(include: :image).merge(url_for(image))
  end

  def destroy
    @car&.destroy
    render json: { message: 'Car Deleted Successfully' }
  end

  private

  def car_params
    params.permit(:name, :model, :price, :description, :photo, :user_id,  :image)
  end

  def set_car
    @car = Car.find(params[:id])
  end
end
