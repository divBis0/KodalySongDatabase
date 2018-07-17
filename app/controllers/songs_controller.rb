class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit, :show]
  before_action :authenticate_user!
  # GET /songs
  # GET /songs.json
  def index
    @q = current_user.songs.search(params[:q])
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
    @song = current_user.songs.new(tmp)
    respond_to do |format|
      if @song.save && (field_entries_attributes.values.map { |values| values[:data].blank? || @song.field_entries.build(values) }.empty? || @song.save)
        format.html { redirect_to @song, notice: 'current_user.songs was successfully created.' }
        format.json { render :show, status: :created, location: @song }
      else
        pp @song.errors.full_messages
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
    respond_to do |format|
      if @song.update(tmp)
        if old_image_id.present? && old_image_id != @song.image_id
          pp Cloudinary::Api.delete_resources([old_image_id])
        end
        if @song.image_id.present? && old_image_id != @song.image_id
          pp "Validating new image: #{@song.image_id}"
          Cloudinary::Uploader.replace_tag("validated", [@song.image_id])
        end
        format.html { redirect_to @song, notice: 'current_user.songs was successfully updated.' }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    if @song.image_id.present?
        pp Cloudinary::Api.delete_resources([@song.image_id])
    end
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'current_user.songs was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
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
      if params[:song][:image_id].present?
        preloaded = Cloudinary::PreloadedFile.new(params[:song][:image_id])         
        raise "Invalid upload signature" if !preloaded.valid?
        params[:song][:image_id] = preloaded.public_id
        params[:song][:image_path] = preloaded.identifier
      end
      if params[:source_sel] == "new"
        params.require(:song).permit(:title, :comments, :image_id, :image_path,
            field_entries_attributes: [:id, :data, :field_id],
            source_attributes: [:id, :title, :author, :publisher, :city, :copyright_year, :website],
            concepts_attributes: [:id, :name, :prepare, :practice, :present, :rhythm, :_destroy])
      else
        params.require(:song).permit(:title, :comments, :source_id, :image_id, :image_path,
            field_entries_attributes: [:id, :data, :field_id],
            concepts_attributes: [:id, :name, :prepare, :practice, :present, :rhythm, :_destroy])
      end
    end
end
