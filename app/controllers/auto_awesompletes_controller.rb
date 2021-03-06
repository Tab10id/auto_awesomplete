class AutoAwesompletesController < ApplicationController
  def search
    begin
      if params[:class_name].present?
        adapter = "::#{params[:class_name].camelize}SearchAdapter".constantize
      elsif params[:default_class_name].present?
        adapter = ::AutoAwesomplete::SearchAdapter::Default
      else
        render json: {error: "not enough search parameters'"},
               status: 500
        return
      end
    rescue NameError
      render json: {error: "not found search adapter for '#{params[:class_name]}'"},
             status: 500
      return
    end

    term = params.delete(:term)
    page = params.delete(:page)
    search_method = params.delete(:search_method)

    render json: adapter.search_from_autocomplete(term, page, search_method, params).uniq
  end
end