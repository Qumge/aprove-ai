require 'test_helper'

class AttachmentTest < ActiveSupport::TestCase
  test 'uses the local storage route for previews by default' do
    previous_mode = ENV['UPLOAD_STORAGE']
    ENV['UPLOAD_STORAGE'] = 'local'

    assert_equal '/uploads/example.pdf', Attachment.new(path: 'example.pdf').preview_url
  ensure
    previous_mode.nil? ? ENV.delete('UPLOAD_STORAGE') : ENV['UPLOAD_STORAGE'] = previous_mode
  end
end
