class ObjectStorage
  MAX_FILE_SIZE = 150.megabytes
  PRESIGN_EXPIRES_IN = 15.minutes
  KEY_PATTERN = /\A[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}(?:\.[a-z0-9]+)?\z/

  class ConfigurationError < StandardError; end

  class << self
    def mode
      ENV.fetch('UPLOAD_STORAGE', Rails.env.production? ? 'r2' : 'local')
    end

    def local?
      mode == 'local'
    end

    def r2?
      mode == 'r2'
    end

    def configured?
      local? || r2_configuration.slice(:account_id, :access_key_id, :secret_access_key, :bucket).values.all?(&:present?)
    end

    def key_for(filename)
      extension = File.extname(filename.to_s).downcase.gsub(/[^a-z0-9.]/, '')
      "#{SecureRandom.uuid}#{extension}"
    end

    def presigned_upload_url(key:, content_type:)
      ensure_configured!
      presigner.presigned_url(
        :put_object,
        bucket: r2_configuration.fetch(:bucket),
        key: key,
        content_type: content_type,
        expires_in: PRESIGN_EXPIRES_IN.to_i
      )
    end

    def url(key)
      return if key.blank?
      return "/uploads/#{key}" if local?

      ensure_configured!
      public_url = r2_configuration[:public_url]
      return "#{public_url.chomp('/')}/#{key}" if public_url.present?

      presigner.presigned_url(
        :get_object,
        bucket: r2_configuration.fetch(:bucket),
        key: key,
        expires_in: 1.hour.to_i
      )
    end

    def local_path(key)
      raise ArgumentError, 'Invalid storage key' unless valid_key?(key)

      Rails.root.join('storage', 'uploads', key)
    end

    def valid_key?(key)
      key.to_s.match?(KEY_PATTERN)
    end

    def ensure_configured!
      return if configured?

      raise ConfigurationError, 'Cloudflare R2 storage is not fully configured'
    end

    private

    def client
      @client ||= Aws::S3::Client.new(
        endpoint: "https://#{r2_configuration.fetch(:account_id)}.r2.cloudflarestorage.com",
        access_key_id: r2_configuration.fetch(:access_key_id),
        secret_access_key: r2_configuration.fetch(:secret_access_key),
        region: 'auto',
        force_path_style: true
      )
    end

    def presigner
      @presigner ||= Aws::S3::Presigner.new(client: client)
    end

    def r2_configuration
      {
        account_id: ENV['R2_ACCOUNT_ID'],
        access_key_id: ENV['R2_ACCESS_KEY_ID'],
        secret_access_key: ENV['R2_SECRET_ACCESS_KEY'],
        bucket: ENV['R2_BUCKET'],
        public_url: ENV['R2_PUBLIC_URL']
      }
    end
  end
end
