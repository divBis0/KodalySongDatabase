class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit, :show]
  before_action :authenticate_user!
  # GET /songs
  # GET /songs.json
  def index
    if params[:alpha].nil?
      @q = current_user.songs.search(params[:q])
    else
      @q = current_user.songs.where('title ILIKE ?',params[:alpha]+'%').search(params[:q])
    end
    @q.sorts = 'title' if @q.sorts.empty?
    @songs = @q.result.page(params[:page])#.to_a.uniq
    #@songs = current_user.songs.page(params[:page])
    # To do:
    # Create list of 
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
  end

  # GET /songs/new
  def new
    @song = current_user.songs.new
    @song.source = current_user.sources.new
    #pp @song
    #@datums = Field.all.to_a.collect{ |fld| @song.field_entries.build(field_id: fld.id) }
    #pp @datums
    #pp @song.field_categories
    Field.all.map{ |fld| @song.field_entries.build(field_id: fld.id) }
    @im_id_cols, @im_paths = set_images(@song)
    @song
  end

  # GET /songs/1/edit
  def edit
    (Field.all - @song.fields).each do |field|
      @song.field_entries.build(field_id: field.id)
    end
    unless @song.source
      @song.source = Source.new
    end
    @im_id_cols, @im_paths = set_images(@song)
    @song
  end

  # POST /songs
  # POST /songs.json
  def create
    tmp = song_params;
    field_entries_attributes = tmp.delete(:field_entries_attributes)
    if tmp[:source_attributes].present?
      tmp[:source_attributes][:user_id] = current_user.id;
    end
    
    im_id_keys = [:image_id, :image2_id, :image3_id, :image4_id]
    im_path_keys = [:image_path, :image2_path, :image3_path, :image4_path]
    im_del_keys = [:_delete_image1, :_delete_image2, :_delete_image3, :_delete_image4]
    im_del_values = im_del_keys.map {|k| tmp[k].to_i}
    im_del_keys.each{|k| tmp.delete(k)}
    k=0;
    for i in 0...4
      unless im_del_values[i]==1
        if tmp[im_id_keys[i]].present?
          if i!=k
            tmp[im_id_keys[k]]   = tmp[im_id_keys[i]]
            tmp[im_path_keys[k]] = tmp[im_path_keys[i]]
          end
          k+=1
        end
      end
    end
    for i in k...4
      if tmp[im_id_keys[k]].present?
        tmp[im_id_keys[i]]   = nil
        tmp[im_path_keys[i]] = nil
      end
    end
    
    @song = current_user.songs.new(tmp)
    respond_to do |format|
      if @song.save && (field_entries_attributes.values.map { |values| values[:data].blank? || @song.field_entries.build(values) }.empty? || @song.save)
        im_id_keys.map {|id| @song[id]}.each do |id|
          if id.present?
            pp "Validating new image: #{id}"
            Cloudinary::Uploader.replace_tag("validated", [id])
          end
        end
      
        format.html { redirect_to @song, notice: 'current_user.songs was successfully created.' }
        format.json { render :show, status: :created, location: @song }
      else
        handle_song_val_error()
        format.html { render :new }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    tmp = song_params;
    tmp[:field_entries_attributes].values.map { |values| values[:data].blank? && values[:_destroy] = true }
    if tmp[:source_attributes].present?
      if tmp[:source_attributes][:id].present?
        tmp[:source_attributes].delete(:id);
      end
      @source = current_user.sources.create(tmp[:source_attributes]);
      tmp[:source_id] = @source.id;
      tmp.delete(:source_attributes);
    end
    old_image_id = @song.image_id
    
    old_im_ids = [@song.image_id, @song.image2_id, @song.image3_id, @song.image4_id]
    im_id_keys = [:image_id, :image2_id, :image3_id, :image4_id]
    im_path_keys = [:image_path, :image2_path, :image3_path, :image4_path]
    im_del_keys = [:_delete_image1, :_delete_image2, :_delete_image3, :_delete_image4]
    im_del_values = im_del_keys.map {|k| tmp[k].to_i}
    im_del_keys.each{|k| tmp.delete(k)}
    
    k=0;
    for i in 0...4
      unless im_del_values[i]==1
        if tmp[im_id_keys[i]].present?
          if i!=k
            tmp[im_id_keys[k]]   = tmp[im_id_keys[i]]
            tmp[im_path_keys[k]] = tmp[im_path_keys[i]]
          end
          k+=1
        elsif @song[im_id_keys[i]].present?
          if i!=k || tmp[im_id_keys[k]].present?
            tmp[im_id_keys[k]]   = @song[im_id_keys[i]]
            tmp[im_path_keys[k]] = @song[im_path_keys[i]]
          end
          k+=1
        end
      end
    end
    for i in k...4
      if tmp[im_id_keys[k]].present? || @song[im_id_keys[i]].present?
        tmp[im_id_keys[i]]   = nil
        tmp[im_path_keys[i]] = nil
      end
    end
    
    respond_to do |format|
      if @song.update(tmp)
        new_im_ids = im_id_keys.map {|id| @song[id]}
        old_im_ids.each do |id|
          if id.present? && !(new_im_ids.include? id)
            pp Cloudinary::Api.delete_resources([id])
          end
        end
        new_im_ids.each do |id|
          if id.present? && !(old_im_ids.include? id)
            pp "Validating new image: #{id}"
            Cloudinary::Uploader.replace_tag("validated", [id])
          end
        end
        
        format.html { redirect_to @song, notice: 'current_user.songs was successfully updated.' }
        format.json { render :show, status: :ok, location: @song }
      else
        handle_song_val_error()
        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    im_ids_to_delete = [:image_id, :image2_id, :image3_id, :image4_id].map{|id| @song[id]}.select{|id| id.present?}
    unless im_ids_to_delete.empty?
      pp Cloudinary::Api.delete_resources(im_ids_to_delete)
    end
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'current_user.songs was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_images(s)
      im_id_cols = [:image_id, :image2_id, :image3_id, :image4_id]
      im_paths = [
        s.image_path.present?  ? s.image_path  : nil,
        s.image2_path.present? ? s.image2_path : nil,
        s.image3_path.present? ? s.image3_path : nil,
        s.image4_path.present? ? s.image4_path : nil]
      return im_id_cols, im_paths
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      unless @song = current_user.songs.where(id: params[:id]).first
        flash[:alert] = 'Song not found.'
        redirect_to root_url
      end
    end
    
    def set_categories
      @categories = FieldCategory.order(:order)
    end
    
    def handle_song_val_error
      pp "Song validation failed:"
      pp @song.errors.full_messages
      set_categories()
      @im_id_cols, @im_paths = set_images(@song)
      @song
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
    #pp [Field.all.map {|f| f.id}, :data]
      #field_entries_attributes = params[:song].delete(:field_entries_attributes)
      #params.require(:song).permit(:title, :comments)#.tap do |whitelisted|
      #  whitelisted[:field_entries_attributes] = field_entries_attributes
      #end
      #pp params.require(:song).permit(:title, :comments, field_entries_attributes: [:id, :data, :field_id])
      #pp params.permitted?
      #params.require(:song).require(:field_entries_attributes).permit(:data)
      pp params
      im_ids = [:image_id, :image2_id, :image3_id, :image4_id]
      im_paths = [:image_path, :image2_path, :image3_path, :image4_path]
      im_ids.zip(im_paths).each do |im_id, im_path|
        if params[:song][im_id].present?
          preloaded = Cloudinary::PreloadedFile.new(params[:song][im_id])         
          raise "Invalid upload signature" if !preloaded.valid?
          params[:song][im_id] = preloaded.public_id
          params[:song][im_path] = preloaded.identifier
        end
      end
      acceptable_fields = [:title, :comments,
            :_delete_image1, :_delete_image2, :_delete_image3, :_delete_image4,
            field_entries_attributes: [:id, :data, :field_id],
            concepts_attributes: [:id, :name, :prepare, :practice, :present, :rhythm, :_destroy]] +
            im_ids + im_paths
      if params[:source_sel] == "new"
        acceptable_fields.push(source_attributes: [:id, :title, :author, :publisher, :city, :copyright_year, :website])
      else
        acceptable_fields.push(:source_id)
      end
      params.require(:song).permit(*acceptable_fields)
    end
end
