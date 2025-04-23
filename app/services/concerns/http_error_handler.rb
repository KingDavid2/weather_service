module HttpErrorHandler
  extend ActiveSupport::Concern

  class_methods do
    def with_error_handler
      response = yield

      if response.is_a?(Hash) && response["cod"] != 200
        return { error: response["message"] || "API error", code: response["cod"] }
      elsif response.is_a?(Array) && response.empty?
        return { error: "Not found", code: 404 }
      end

      response.is_a?(Array) ? response.first : response
    rescue HTTParty::Error => e
      { error: "HTTParty error: #{e.message}" }
    rescue StandardError => e
      { error: "Unexpected error: #{e.message}" }
    end
  end
end
