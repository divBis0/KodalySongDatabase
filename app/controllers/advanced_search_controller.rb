class AdvancedSearchController < ApplicationController
  before_action :set_search_fields, only: [:index, :list]
  before_action :authenticate_user!
  
  # GET /advanced_search
  def index
    @songs = []
    validate_params(params)
    qresults = []
    # TODO: add more parameter/query validation
    if @aq.key? :f1
      qresults.push([0,do_query(@aq[:f1], @aq[:q1]),lkup(@aq[:f1]),@aq[:q1]])
    end
    if @aq.key? :f2
      qresults.push([@aq[:b12],do_query(@aq[:f2], @aq[:q2]),lkup(@aq[:f2]),@aq[:q2]])
    end
    if @aq.key? :f3
      qresults.push([@aq[:b23],do_query(@aq[:f3], @aq[:q3]),lkup(@aq[:f3]),@aq[:q3]])
    end
    if @aq.key? :f4
      qresults.push([@aq[:b34],do_query(@aq[:f4], @aq[:q4]),lkup(@aq[:f4]),@aq[:q4]])
    end
    # First, invert results
    for i in 0...qresults.length
      if qresults[i][2][2]['data-type'] == 'rhythm'
        txt = "#RhYtHm#"+qresults[i].pop+"#RhYtHm#"
      else
        txt = qresults[i].pop
      end
      if qresults[i][0] > 2
        if !(defined? all_songs)
          all_songs = current_user.songs.all
        end
        qresults[i][0] -= 2
        qresults[i][1] = all_songs - qresults[i][1]
        qresults[i][2] = qresults[i][2][0] + " does NOT contain '" + txt + "'"
      else
        qresults[i][2] = qresults[i][2][0] + " contains '" + txt + "'"
      end
    end
    # Second, collapse ORs
    q2 = []
    s2 = []
    qresults.each do |qr|
      if qr[0] == 2
        q2.push(q2.pop | qr[1])
        s1=s2.pop
        if s1.end_with?(')')
          s2.push(s1[0...-1]+" OR "+qr[2]+')')
        else
          s2.push('('+s1+" OR "+qr[2]+')')
        end
      else
        q2.push(qr[1])
        s2.push(qr[2])
      end
    end
    # Collapse ANDs
    @searchstring = s2.join(" AND ").split("#RhYtHm#")
    # If everything is an OR, we might end up with unnecessary parentheses
    if /^\([^\(\)]*\)$/.match(@searchstring.join(' '))
      @searchstring[0] = @searchstring[0][1..-1]
      @searchstring[-1] = @searchstring[-1][0..-2]
    end
    for i in 0...q2.length
      if i==0
        @songs = q2[0].to_a
      else
        @songs &= q2[i].to_a
      end
    end
    if @songs.length > 1
      @songs.uniq!
      @songs.sort_by!{|obj| obj.title}
    end
  end
  def list
    # TODO: add more parameter/query validation
    @title = params[:title].split('\n')
    @songs = current_user.songs.where(id: params[:songs].split(',').map(&:to_i))
    @fields = params[:fields].map{|f| lkup(f.to_i)}
  end
  def show
    # TODO: add more parameter/query validation
    @songs = current_user.songs.where(id: params[:songs].split(',').map(&:to_i))
    @categories = FieldCategory.order(:order)
  end
  
  private
    def lkup(field_ix)
      return @searchfields.select{|sf| sf[1]==field_ix}.first
    end
    def valid_query(field_ix,field_val)
      return !(!field_val || field_val.blank? || field_ix==0)
    end
    def validate_params(params)
      @aq = {}
      @sf = {}
      if valid_query(params[:f1].to_i, params[:q1])
        @aq[:f1] = params[:f1].to_i
        @aq[:q1] = params[:q1]
        @sf[:f1] = lkup(@aq[:f1])
      else
        @sf[:f1] = @searchfields[0]
      end
      if valid_query(params[:f2].to_i, params[:q2])
        @aq[:b12]= params[:b12].to_i
        @aq[:f2] = params[:f2].to_i
        @aq[:q2] = params[:q2]
        @sf[:f2] = lkup(@aq[:f2])
      else
        @sf[:f2] = @searchfields[0]
      end
      if valid_query(params[:f3].to_i, params[:q3])
        @aq[:b23]= params[:b23].to_i
        @aq[:f3] = params[:f3].to_i
        @aq[:q3] = params[:q3]
        @sf[:f3] = lkup(@aq[:f3])
      else
        @sf[:f3] = @searchfields[0]
      end
      if valid_query(params[:f4].to_i, params[:q4])
        @aq[:b34]= params[:b34].to_i
        @aq[:f4] = params[:f4].to_i
        @aq[:q4] = params[:q4]
        @sf[:f4] = lkup(@aq[:f4])
      else
        @sf[:f4] = @searchfields[0]
      end
    end
    def do_query(field_ix,field_val)
      case field_ix
      when 1
        qstr = 'songs.title ILIKE ?'
      when 2
        qstr = 'sources.title ILIKE ?'
      when 3
        qstr = 'sources.author ILIKE ?'
      when 4, 8
        qstr = 'concepts.name ILIKE ?'
      when 5, 9
        qstr = 'concepts.prepare = TRUE AND concepts.name ILIKE ?'
      when 6, 10
        qstr = 'concepts.present = TRUE AND concepts.name ILIKE ?'
      when 7, 11
        qstr = 'concepts.practice = TRUE AND concepts.name ILIKE ?'
      when 12...(@searchfields.length-1)
        # Deduce field_name for field
        fname = @searchfields.detect{|x| x[1]==field_ix}[0]
        # Deduce field_id for field
        fid = Field.select(:id,:name).where('name = ?',fname).limit(1).first.id
        qstr = 'field_entries.field_id = '+fid.to_s+' AND field_entries.data ILIKE ?'
      when @searchfields.length-1
        qstr = 'songs.comments ILIKE ?'
      else
        qstr = ''
      end
      
      return do_eager_load(current_user.songs,field_ix).where(qstr,'%'+field_val+'%')
    end
    def do_eager_load(q_in,field_ix)
      case field_ix
      when 1,@searchfields.length-1
        return q_in
      when 2,3
        return q_in.eager_load(:source)
      when 4..11
        return q_in.eager_load(:concepts)
      else
        return q_in.eager_load(:field_entries)
      end
    end
    def set_search_fields
      # Create list of searchable fields
      @searchfields = [
        #['(Any Field)',0,{'data-type' => 'text'}],
        ['',0,{'data-type' => 'text'}],
        ['Title',1,{'data-type' => 'text'}],
        ['Source Title',2,{'data-type' => 'text'}],
        ['Source Author',3,{'data-type' => 'text'}],
        ['Regular Concept',4,{'data-type' => 'text'}],
        ['Prepare Regular Concept',5,{'data-type' => 'text'}],
        ['Present Regular Concept',6,{'data-type' => 'text'}],
        ['Practice Regular Concept',7,{'data-type' => 'text'}],
        ['Rhythm Concept',8,{'data-type' => 'rhythm'}],
        ['Prepare Rhythm Concept',9,{'data-type' => 'rhythm'}],
        ['Present Rhythm Concept',10,{'data-type' => 'rhythm'}],
        ['Practice Rhythm Concept',11,{'data-type' => 'rhythm'}]]
      i=@searchfields.length-1
      FieldCategory.order(:order).each do |cat|
        Field.all.select{ |fe| fe.field_category == cat }.each do |ff|
          i=i+1
          if ff.display_type == "rhythm"
            @searchfields.push([ff.name,i,{'data-type' => 'rhythm'}])
          elsif ff.display_type == "tone_set"
            @searchfields.push([ff.name,i,{'data-type' => 'tone'}])
          else
            @searchfields.push([ff.name,i,{'data-type' => 'text'}])
          end
        end
      end
      @searchfields.push(['Comments',i+1,{'data-type' => 'text'}])
      @searchbinaryops = [['And',1],['Or',2],['And Not',3],['Or Not',4]]
      @default_index_list = @searchfields.each_index.select{|i|
          ['Title','Source Title','Page #','Grade Levels'].include? @searchfields[i][0]}.sort
    end
end