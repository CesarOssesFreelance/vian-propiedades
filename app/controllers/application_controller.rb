class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :redirect_to_canonical_host
  private

  def redirect_to_canonical_host
    return unless Rails.env.production? && request.host == "www.vianpropiedades.cl"

    redirect_to request.url.sub("://www.vianpropiedades.cl", "://vianpropiedades.cl"),
                status: :permanent_redirect, allow_other_host: true
  end

  def authorize_catalog_management!
    head :forbidden unless current_user&.admin? || current_user&.super_admin?
  end

  def authorize_user_management!
    head :forbidden unless current_user&.super_admin?
  end
end
