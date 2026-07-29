require 'test_helper'

class DirectUploadsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @previous_mode = ENV['UPLOAD_STORAGE']
    ENV['UPLOAD_STORAGE'] = 'local'
    sign_in users(:one)
  end

  teardown do
    @previous_mode.nil? ? ENV.delete('UPLOAD_STORAGE') : ENV['UPLOAD_STORAGE'] = @previous_mode
    FileUtils.rm_f(ObjectStorage.local_path(@uploaded_key)) if @uploaded_key
  end

  test 'uploads and serves a local file' do
    content = 'local storage test'
    post direct_uploads_presign_path,
         params: { filename: 'example.txt', content_type: 'text/plain', size: content.bytesize },
         as: :json

    assert_response :success
    upload = response.parsed_body
    @uploaded_key = upload.fetch('key')

    put upload.fetch('upload_url'), params: content, headers: upload.fetch('headers')

    assert_response :no_content

    get stored_upload_path(@uploaded_key)

    assert_response :success
    assert_equal content, response.body
  end

  test 'rejects invalid local storage keys' do
    get '/uploads/not-a-storage-key.pdf'

    assert_response :not_found
  end
end
