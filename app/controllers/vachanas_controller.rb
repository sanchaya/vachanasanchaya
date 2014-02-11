class VachanasController < ApplicationController
  # GET /vachanas
  # GET /vachanas.json
  #check if logged_in user is Admin
  before_filter :authenticate_user_role! , only: [:new, :edit,:create,:update,:destroy]
  # caches_action :index, :cache_path => Proc.new { |c| c.params }


  def index
    @word_lists = WordList.all
    @vachanakaaras_list =  Vachanakaara.all
    if params[:vachana] and !params[:vachana].blank? 
      @pada = params[:vachana].squish
      @search_type = params[:search_type]
      @vachanakaara_id = params[:vachanakaara]
      @vachanas, @vachanakaaras_word_count, @vachanakaaras_name,@total_counts  = KeyWord.search_vachana_pada(@pada,@search_type,@vachanakaara_id)
      if params[:vachanakaara] and !params[:vachanakaara].blank?
        @vachanakaaras = [Vachanakaara.find(params[:vachanakaara].to_i)]
      else
        @vachanakaaras = @vachanas.vachanakaaras
      end
      @results = @vachanas.paginate(:page => params[:page], :per_page => 15)
      # @vachanas,@vachanakaaras_word_count, @vachanakaaras_name, @vachanakaaras_total_count , @vachanakaaras = Vachana.search_vachana_pada(@pada,@search_type,@vachanakaara)
      # @counts = @vachanas.values
      # @total_counts = @counts.inject{|sum,x| sum + x }
      # flash[:notice] = "Got #{@total_counts ? @total_counts: "0"} #{'result'.pluralize(@total_counts)} for #{@pada}"
      respond_to do |format|
      format.html # index.html.erb
      format.js
    end
  else
    flash[:notice] = "ಕನಿಷ್ಟ 2 ಅಕ್ಷರವನ್ನು ಬೆರಳಚ್ಚು ಮಾಡಿ"
    redirect_to :back 
  end
  
end

  # GET /vachanas/1
  # GET /vachanas/1.json
  def show
    @vachana = Vachana.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vachana }
    end
  end

  # GET /vachanas/new
  # GET /vachanas/new.json
  def new
    @vachana = Vachana.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vachana }
    end
  end

  # GET /vachanas/1/edit
  def edit
    @vachana = Vachana.find(params[:id])
  end

  # POST /vachanas
  # POST /vachanas.json
  def create
    @vachana = Vachana.new(params[:vachana])

    respond_to do |format|
      if @vachana.save
        format.html { redirect_to @vachana, notice: 'Vachana was successfully created.' }
        format.json { render json: @vachana, status: :created, location: @vachana }
      else
        format.html { render action: "new" }
        format.json { render json: @vachana.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vachanas/1
  # PUT /vachanas/1.json
  def update
    @vachana = Vachana.find(params[:id])

    respond_to do |format|
      if @vachana.update_attributes(params[:vachana])
        format.html { redirect_to @vachana, notice: 'Vachana was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vachana.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vachanas/1
  # DELETE /vachanas/1.json
  def destroy
    @vachana = Vachana.find(params[:id])
    @vachana.destroy

    respond_to do |format|
      format.html { redirect_to vachanas_url }
      format.json { head :no_content }
    end
  end

  def vachana_concord
   params[:start_letter] = params[:start_letter] ? params[:start_letter] : "ಅ"
   @vachanas= Vachana.start_letter(params[:start_letter]).paginate(:page => params[:page], :per_page => 15)

   respond_to do |format|
    format.html
  format.js # actually means: if the client ask for js -> return file.js
end
end

def search_vachana_number
  @vachanas = Vachana.where(vachanaid: params[:vachana_number].to_i)
end


end
