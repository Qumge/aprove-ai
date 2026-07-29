class DirectUploadsController < ApplicationController
  MAX_CONTENT_TYPE_LENGTH = 255
  skip_before_action :check_authorization_for_action

  def presign
    filename = params.require(:filename).to_s
    content_type = params[:content_type].presence || 'application/octet-stream'
    size = params.require(:size).to_i

    return render json: { error: 'File is too large' }, status: :unprocessable_entity if size > ObjectStorage::MAX_FILE_SIZE
    return render json: { error: 'File is empty' }, status: :unprocessable_entity if size <= 0
    return render json: { error: 'Invalid content type' }, status: :unprocessable_entity if content_type.length > MAX_CONTENT_TYPE_LENGTH

    key = ObjectStorage.key_for(filename)
    if ObjectStorage.local?
      token = upload_verifier.generate(
        { key: key, content_type: content_type, size: size },
        expires_in: ObjectStorage::PRESIGN_EXPIRES_IN
      )
      render json: {
        key: key,
        upload_url: local_direct_uploads_path(token: token),
        headers: { 'Content-Type' => content_type }
      }
    else
      render json: {
        key: key,
        upload_url: ObjectStorage.presigned_upload_url(key: key, content_type: content_type),
        headers: { 'Content-Type' => content_type }
      }
    end
  rescue ObjectStorage::ConfigurationError => error
    render json: { error: error.message }, status: :service_unavailable
  end

  def local
    return head :not_found unless ObjectStorage.local?

    payload = upload_verifier.verify(params.require(:token)).with_indifferent_access
    return head :payload_too_large if request.content_length.to_i > ObjectStorage::MAX_FILE_SIZE
    return head :unprocessable_entity unless request.content_length.to_i == payload.fetch(:size)

    path = ObjectStorage.local_path(payload.fetch(:key))
    FileUtils.mkdir_p(path.dirname)
    File.open(path, 'wb') { |file| IO.copy_stream(request.body, file) }
    head :no_content
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    head :forbidden
  end

  def show
    return head :not_found unless ObjectStorage.local?
    return head :not_found unless ObjectStorage.valid_key?(params[:key])

    path = ObjectStorage.local_path(params.require(:key))
    return head :not_found unless path.file?

    send_file path, disposition: 'inline'
  end

  private

  def upload_verifier
    Rails.application.message_verifier(:direct_upload)
  end
end
