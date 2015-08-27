module AutoAwesomplete::Helpers
  module RailsHelper
    def ajax_awesomplete_init_script
      unless @auto_awesomplete_ajax_script_included
        @auto_awesomplete_ajax_script_included = true
        javascript_include_tag('auto_awesomplete/ajax')
      end
    end
  end
end