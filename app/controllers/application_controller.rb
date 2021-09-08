class ApplicationController < ActionController::API

  def page
    min_page_number = 1
    ([params.fetch(:page, min_page_number).to_i, min_page_number].max - min_page_number) * per_page
  end

  def per_page
    default = 20
    [ params.fetch(:per_page, default).to_i, default ].max
  end

  def record_not_found
    render json: {"error" => "404 Not Found"}, status: 404
  end

end
