class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  private

  def authorize_catalog_management!
    allowed = current_user&.admin? || (current_user&.corredor? && action_name != "destroy")
    head :forbidden unless allowed
  end
end
