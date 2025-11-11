class ShortUrl < ApplicationRecord
  has_many :clicks, dependent: :delete_all

  validates :original_url, presence: true
  validates :short_code, presence: true, uniqueness: true
  validates :original_url, uniqueness: { conditions: -> { where(deactivated_at: nil) }, message: "already shortened and active" }

  before_validation :normalize_original_url
  before_validation :assign_short_code, on: :create

  scope :active, -> { where(deactivated_at: nil) }

  def active?
    deactivated_at.nil?
  end

  def deactivate!
    update!(deactivated_at: Time.current)
  end

  def url
    host ||= Rails.application.routes.default_url_options[:host]
    return "/#{short_code}" unless host

    "#{host.chomp('/')}/#{short_code}"
  end

  private


  def normalize_original_url
    return if original_url.blank?
    uri = URI.parse(original_url) rescue nil
    raise ActiveRecord::RecordInvalid.new(self), "Invalid URL" unless uri&.scheme && uri.host
    # Basic normalization: downcase scheme/host, strip spaces
    uri.scheme = uri.scheme.downcase
    uri.host = uri.host.downcase
    self.original_url = uri.to_s.strip
  end

  def assign_short_code
    return if short_code.present?
    loop do
      code = ShortCodeGenerator.call
      unless self.class.exists?(short_code: code)
        self.short_code = code
        break
      end
    end
  end
end
