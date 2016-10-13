require 'authenticator'

class ApplicationController < ActionController::Base
  include Pundit
  include Rescuable
  include Filterable
  include Paginatable
  include Sortable
  include Includable

  class << self
    attr_accessor :resource, :serializer_class, :service_class, :schema_class
  end

  delegate :resource, :serializer_class, :schema_class, to: :'self.class'

  attr_reader :current_user
  before_action :set_format, :set_user

  def root
    render json: { }
  end

  def index
    authorize resource
    scoped = sort filter policy_scope resource_scope
    render json: paginate(scoped), include: includes
  end

  def show
    scoped = resource.where(id: resource_ids)
    authorize scoped
    render json: scoped, include: includes
  end

  def create
    service.create!
    render json: service.instance
  end

  def update
    service.update!
    render json: service.instance
  end

  def destroy
    service.destroy!
    render json: { }, status: :no_content
  end

  def service
    @service ||= service_class.new(self)
  end

  def service_class
    self.class.service_class || ApplicationService
  end

  def resource_scope
    resource
  end

  def resource_ids
    if params[:id].is_a? String
      list = params[:id].split(',').compact
      list.collect(&:to_i).reject(&:zero?).uniq
    else
      Array.wrap params.fetch(:id, [])
    end
  end

  def set_format
    request.format = :json if request.format == :json_api
  end

  def set_user
    @current_user = User.from_jwt Authenticator.from_headers request.headers
  end
end
