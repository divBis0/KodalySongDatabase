# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
cat = FieldCategory.create(:name => "Source", :order => 1)
Field.create(:name => "Author", :display_type => "str", :field_category => cat)
Field.create(:name => "Publisher", :display_type => "str", :field_category => cat)
Field.create(:name => "City", :display_type => "str", :field_category => cat)
Field.create(:name => "Copyright Year", :display_type => "num", :field_category => cat)
Field.create(:name => "Page #", :display_type => "num", :field_category => cat)
cat = FieldCategory.create(:name => "Form", :order => 2)
Field.create(:name => "Sectional Form", :display_type => "str", :field_category => cat)
Field.create(:name => "Form Features", :display_type => "str", :field_category => cat)
Field.create(:name => "Phrasal Form", :display_type => "str", :field_category => cat)
