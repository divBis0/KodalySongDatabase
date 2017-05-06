class RhythmInput < SimpleForm::Inputs::TextInput
  def input_html_classes
    super.push('notation')
  end
end