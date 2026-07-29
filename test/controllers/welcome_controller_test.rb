require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test 'renders the English welcome page and remembers the locale' do
    get root_path, params: { locale: 'en' }

    assert_response :success
    assert_select 'html[lang="en"]'
    assert_select '.welcome-hero h1', text: /Turn complex projects/

    get new_user_session_path

    assert_response :success
    assert_select 'html[lang="en"]'
    assert_select '.auth-card h2', text: 'Sign in to your workspace'
  end

  test 'renders Chinese by default' do
    get root_path

    assert_response :success
    assert_select 'html[lang="zh-CN"]'
    assert_select '.welcome-hero h1', text: /把复杂项目/
  end
end
