module SongsHelper
  def link_to_add_concept_fields(f, table_id, song, is_rhythm)
    new_object = song.concepts.build(rhythm: is_rhythm);
    placeholder_ix = is_rhythm ? "new_rhythm_concept" : "new_concept";
    fields = f.fields_for(:concepts, new_object,
        :child_index => placeholder_ix) do |ff|
      ff.object.rhythm = is_rhythm
      render("concept_fields", :f => ff)
    end
    button_tag("Add New #{is_rhythm ? 'Rhythm' : 'Regular'} Concept", :type=>'button', :data=>{:fields => "#{fields}", :placeholder_ix=>placeholder_ix  }, :class=>"add-concept button")
  end
end
