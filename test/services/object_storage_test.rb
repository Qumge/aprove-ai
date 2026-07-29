require 'test_helper'

class ObjectStorageTest < ActiveSupport::TestCase
  test 'generates opaque keys while preserving a safe extension' do
    key = ObjectStorage.key_for('../../Quarterly Report.PDF')

    assert_match(/\A[0-9a-f-]+\.pdf\z/, key)
    refute_includes key, 'Quarterly'
  end

  test 'local storage is configured without cloud credentials' do
    previous_mode = ENV['UPLOAD_STORAGE']
    ENV['UPLOAD_STORAGE'] = 'local'

    assert ObjectStorage.local?
    assert ObjectStorage.configured?
  ensure
    previous_mode.nil? ? ENV.delete('UPLOAD_STORAGE') : ENV['UPLOAD_STORAGE'] = previous_mode
  end

  test 'builds local paths only for generated keys' do
    key = '5d474a8c-20b5-4de3-a838-279ba385588e.pdf'

    assert_equal Rails.root.join('storage', 'uploads', key), ObjectStorage.local_path(key)
    assert_raises(ArgumentError) { ObjectStorage.local_path('../private.txt') }
  end

  test 'builds Cloudflare R2 presigned upload URLs' do
    values = {
      'UPLOAD_STORAGE' => 'r2',
      'R2_ACCOUNT_ID' => 'test-account',
      'R2_ACCESS_KEY_ID' => 'test-access-key',
      'R2_SECRET_ACCESS_KEY' => 'test-secret-key',
      'R2_BUCKET' => 'test-bucket'
    }
    previous_values = values.keys.to_h { |key| [key, ENV[key]] }
    values.each { |key, value| ENV[key] = value }

    url = ObjectStorage.presigned_upload_url(key: 'example.pdf', content_type: 'application/pdf')

    assert ObjectStorage.configured?
    assert_includes url, 'test-account.r2.cloudflarestorage.com'
    assert_includes url, 'test-bucket/example.pdf'
    assert_includes url, 'X-Amz-Signature'
  ensure
    previous_values.each { |key, value| value.nil? ? ENV.delete(key) : ENV[key] = value }
    ObjectStorage.instance_variable_set(:@client, nil)
    ObjectStorage.instance_variable_set(:@presigner, nil)
  end
end
