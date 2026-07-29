require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include LucideRails::RailsHelper

  test 'renders Lucide icons with the shared class' do
    icon = ui_icon('search')

    assert_includes icon, '<svg'
    assert_includes icon, 'class="app-icon"'
    refute_includes icon, 'class="ui-icon"'
    assert_includes icon, 'aria-hidden="true"'
  end

  test 'localizes option labels without changing stored values' do
    I18n.with_locale(:en) do
      options = localized_options(
        [['sample', '样品'], ['normal', '订单']],
        'sections.orders.types'
      )

      assert_equal [['Sample', 'sample'], ['Order', 'normal']], options
    end
  end

  test 'falls back to a readable English label for report columns' do
    I18n.with_locale(:en) do
      assert_equal 'Order number', format_select_column('orders.no')
      assert_equal 'Contact phone', format_select_column('projects.contact_phone')
    end
  end

end
