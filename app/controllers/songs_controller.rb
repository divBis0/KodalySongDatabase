class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit, :show]
  before_action :authenticate_user!
  # GET /songs
  # GET /songs.json
  def index
    @songs = current_user.songs.page(params[:page])
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
  end

  # GET /songs/new
  def new
    @song = current_user.songs.new
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
    @song
  end

  # POST /songs
  # POST /songs.json
  def create
    tmp = song_params;
    field_entries_attributes = tmp.delete(:field_entries_attributes)
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
    respond_to do |format|
      if @song.update(tmp)
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
      #pp params
      params.require(:song).permit(:title, :comments, :source_id, field_entries_attributes: [:id, :data, :field_id])
    end
end
