require 'action_view'

class RhythmSetInput < SimpleForm::Inputs::TextInput
  include ActionView::Helpers::FormTagHelper
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    
    str = "<table><tr>"
    unless @builder.object.data.blank?
      @builder.object.data.split(/;\s*/).each do |d|
        str += "<td>"+text_field_tag(nil, d, :class => "rhythm notation")+"</td>"
      end
    else
      str += "<td>"+text_field_tag(nil, nil, :class => "rhythm notation")+"</td>"
    end
    str += '<td><button name="button" type="button" class="add-rhythm-item button">+</button></td>'
    str += "</tr></table>"
    str += @builder.hidden_field(attribute_name, merged_input_options)
    return str.html_safe
  end
end