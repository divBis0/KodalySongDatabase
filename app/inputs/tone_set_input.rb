class ToneSetInput < SimpleForm::Inputs::TextInput
  def input_html_classes
    super.push('tones')
  end
end