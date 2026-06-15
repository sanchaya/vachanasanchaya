class VachanasController < ApplicationController
  # GET /vachanas
  # GET /vachanas.json
  #check if logged_in user is Admin
  before_filter :authenticate_user_role! , only: [:new, :edit,:create,:update,:destroy]
  caches_action :index, :cache_path => Proc.new { |c| c.params }, :expires_in => 30.minutes

  def index
    @word_lists = WordList.all
    @vachanakaaras_list =  Vachanakaara.all
    if params[:vachana] and !params[:vachana].blank? 
      @pada = params[:vachana].squish
      @search_type = params[:search_type]
      @vachanakaara_id = params[:vachanakaara]
      @vachanas, @vachanakaaras_word_count, @vachanakaaras_name,@total_counts  = KeyWord.search_vachana_pada(@pada,@search_type,@vachanakaara_id)

      # Calculate letter counts from search results only
      search_letters = ["ಅ", "ಆ", "ಇ", "ಈ", "ಉ", "ಊ", "ಋ", "ೠ", "ಎ", "ಏ", "ಐ", "ಒ", "ಓ", "ಔ", "ಅಂ", "ಅಃ",
        "ಕ", "ಖ", "ಗ", "ಘ", "ಙ", "ಚ", "ಛ", "ಜ", "ಝ", "ಞ",
        "ಟ", "ಠ", "ಡ", "ಢ", "ಣ", "ತ", "ಥ", "ದ", "ಧ", "ನ",
        "ಪ", "ಫ", "ಬ", "ಭ", "ಮ", "ಯ", "ರ", "ಱ", "ಲ", "ವ", "ಶ", "ಷ", "ಸ", "ಹ", "ಳ"]
      @search_letter_counts = Hash.new(0)
      @vachanas.pluck(:vachana).compact.each do |v|
        first = v[0]
        @search_letter_counts[first] += 1 if first
      end

      # Calculate keyword occurrence count per vachana from KeyWord records
      keyword_results = if @search_type == "like_search"
        KeyWord.where("word LIKE ?", "%#{@pada}%")
      else
        KeyWord.where(word: @pada)
      end
      @vachana_occurrences = Hash.new(0)
      keyword_results.each do |kr|
        kr.vachana_ids.each { |v_id, c| @vachana_occurrences[v_id.to_i] += c }
      end

      if params[:vachanakaara] and !params[:vachanakaara].blank?
        @vachanakaaras = [Vachanakaara.find(params[:vachanakaara].to_i)]
      else
        @vachanakaaras = @vachanas.vachanakaaras
      end
      @original_total_counts = @total_counts
      @original_vachanakaaras_count = @vachanakaaras.count
      @original_vachanas_count = @vachanas.count

      # Build keyword occurrence count per vachanakaara (parallel to @vachanakaaras_word_count)
      vachana_ids_by_va = @vachanas.select("id, vachanakaara_id").map { |v| [v.id, v.vachanakaara_id] }.group_by(&:last)
      @vachanakaaras_keyword_count = []
      @vachanakaaras.each do |va|
        ids = (vachana_ids_by_va[va.id] || []).map(&:first)
        @vachanakaaras_keyword_count << ids.sum { |v_id| @vachana_occurrences[v_id] }
      end

      if params[:start_letter].present?
        @vachanas = @vachanas.start_letter(params[:start_letter])
        @vachanakaaras = @vachanas.vachanakaaras.uniq
        vachana_ids_by_va = @vachanas.select("id, vachanakaara_id").map { |v| [v.id, v.vachanakaara_id] }.group_by(&:last)
        @vachanakaaras_word_count = []
        @vachanakaaras_name = []
        @vachanakaaras_keyword_count = []
        @vachanakaaras.each do |vachanakaara|
          ids = (vachana_ids_by_va[vachanakaara.id] || []).map(&:first)
          @vachanakaaras_word_count << ids.length
          @vachanakaaras_name << '<span><span style="display:none">' + "#{vachanakaara.id}" + '</span>' + "#{vachanakaara.name}" + '</span>'
          @vachanakaaras_keyword_count << ids.sum { |v_id| @vachana_occurrences[v_id] }
        end
      end
      @results = @vachanas.paginate(:page => params[:page], :per_page => 15)
      set_meta_tags(
        title:       "#{@pada} - ವಚನ ಹುಡುಕಾಟ ಫಲಿತಾಂಶಗಳು - ವಚನ ಸಂಚಯ",
        description: "#{@pada} ಪದಕ್ಕಾಗಿ #{@total_counts || 0} ವಚನ ಫಲಿತಾಂಶಗಳು. ವಚನ ಸಂಚಯದಲ್ಲಿ ವಚನಗಳನ್ನು ಮತ್ತು ವಚನಕಾರರನ್ನು ಹುಡುಕಿ.",
        keywords:    "#{@pada}, ವಚನ ಹುಡುಕಾಟ, ವಚನ ಸಾಹಿತ್ಯ, ಕನ್ನಡ ಸಾಹಿತ್ಯ"
      )
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
    vachana_text = @vachana.vachana.to_s.truncate(160, separator: ' ')
    set_meta_tags(
      title:       "#{@vachana.vachanakaara.name} - ವಚನ #{@vachana.vachanaid} - ವಚನ ಸಂಚಯ",
      description: "#{vachana_text}",
      keywords:    "#{@vachana.vachanakaara.name}, ವಚನ, ವಚನ ಸಾಹಿತ್ಯ, ಕನ್ನಡ ಸಾಹಿತ್ಯ"
    )

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
    if(@vachana)
      @vachana.destroy
    end


    respond_to do |format|
      format.html { redirect_to new_vachana_url }
      format.json { head :no_content }
    end
  end

  def vachana_concord
    params[:start_letter] = params[:start_letter] ? params[:start_letter] : "ಅ"
    @vachanas = Vachana.start_letter(params[:start_letter])
    @vachanas = @vachanas.paginate(:page => params[:page], :per_page => 15)
    
    set_meta_tags(
      title:       "#{params[:start_letter]} ಪದದಿಂದ ಪ್ರಾರಂಭವಾಗುವ ವಚನಗಳು - ವಚನ ಸಂಚಯ",
      description: "#{params[:start_letter]} ಅಕ್ಷರದಿಂದ ಪ್ರಾರಂಭವಾಗುವ ವಚನಗಳ ಪಟ್ಟಿ. ವಚನ ಸಂಚಯದಲ್ಲಿ ವಚನಗಳನ್ನು ಅಕ್ಷರಾನುಕ್ರಮವಾಗಿ ವೀಕ್ಷಿಸಿ.",
      keywords:    "#{params[:start_letter]}, ವಚನಗಳು, ವಚನ ಸಂಚಯ, ಕನ್ನಡ ಸಾಹಿತ್ಯ"
    )
    respond_to do |format|
     format.html
     format.js
    end
  end

def search_vachana_number
  @vachanas = Vachana.where(vachanaid: params[:vachana_number].to_i)
  set_meta_tags(
    title:       "ವಚನ ಸಂಖ್ಯೆ #{params[:vachana_number]} - ವಚನ ಸಂಚಯ",
    description: "ವಚನ ಸಂಖ್ಯೆ #{params[:vachana_number]} ಗಾಗಿ ವಚನ ಫಲಿತಾಂಶಗಳು.",
    keywords:    "#{params[:vachana_number]}, ವಚನ ಸಂಖ್ಯೆ, ವಚನ ಸಂಚಯ"
  )
end

# Full text search on vachana
def search_vachana
 @search = Vachana.search do
  fulltext params[:search]
end
@vachanas = @search.results
  set_meta_tags(
    title:       "#{params[:search]} - ಪೂರ್ಣಪಠ್ಯ ಹುಡುಕಾಟ - ವಚನ ಸಂಚಯ",
    description: "#{params[:search]} ಪದಕ್ಕಾಗಿ ಪೂರ್ಣಪಠ್ಯ ವಚನ ಹುಡುಕಾಟ ಫಲಿತಾಂಶಗಳು.",
    keywords:    "#{params[:search]}, ಪೂರ್ಣಪಠ್ಯ ಹುಡುಕಾಟ, ವಚನ ಸಂಚಯ"
  )
end

def download_vachana_csv
  require 'csv'
  @vachanas = Vachana.all
  send_data(
    Vachana.all_vachanas,
    :type => 'text/csv',
    :filename => 'vachanas.csv',
    :disposition => 'attachment'
    )
end

def ai_search
  if params[:q].present?
    service = AiSearchService.new(params[:q])
    @result = service.call
    @query = params[:q]
  end
  set_meta_tags(
    title:       "AI ವಚನ ಸಂಶೋಧನೆ - ವಚನ ಸಂಚಯ",
    description: "AI-ಚಾಲಿತ ವಚನ ಸಂಶೋಧನಾ ಸಾಧನ. ವಚನ ಸಾಹಿತ್ಯದ ಬಗ್ಗೆ ನಿಮ್ಮ ಪ್ರಶ್ನೆಗಳನ್ನು ಕೇಳಿ.",
    keywords:    "AI, ವಚನ ಸಂಶೋಧನೆ, ವಚನ ಸಾಹಿತ್ಯ, ಕನ್ನಡ"
  )
  respond_to do |format|
    format.html
  end
end

end
