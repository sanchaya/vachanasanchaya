class VachanasController < ApplicationController
  # GET /vachanas
  # GET /vachanas.json
  def index
    @word_lists = WordList.all
    @vachanakaras =  Vachanakaara.all
    if params[:vachana]
      @pada = params[:vachana]
      @search_type = params[:search_type]
      @vachanakaara = params[:vachanakaara]
      @vachanas,@vachanakaaras_word_count, @vachanakaaras_name, @vachanakaaras_total_count , @vachanakaaras = Vachana.search_vachana_pada(@pada,@search_type,@vachanakaara)
      @counts = @vachanas.values
      @total_counts = @counts.inject{|sum,x| sum + x }
      # flash[:notice] = "Got #{@total_counts ? @total_counts: "0"} #{'result'.pluralize(@total_counts)} for #{@pada}"
    end
    respond_to do |format|
      format.html # index.html.erb
      format.js
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
end
