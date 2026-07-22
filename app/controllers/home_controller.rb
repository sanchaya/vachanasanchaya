class HomeController < ApplicationController
  before_filter :authenticate_user_role! , only: [:admin_panel, :feedbacks, :update_feedback]
  
  def index
    set_meta_tags(
      title:       "ವಚನ ಸಂಚಯ - ವಚನ ಸಾಹಿತ್ಯ ಸಂಶೋಧನೆ ಮತ್ತು ಅಧ್ಯಯನ ತಾಣ",
      description: "ವಚನ ಸಂಚಯವು ೨೫,೦೦೦ಕ್ಕೂ ಹೆಚ್ಚು ವಚನಗಳನ್ನು ಮತ್ತು ೨೫೦ಕ್ಕೂ ಹೆಚ್ಚು ವಚನಕಾರರನ್ನು ಒಳಗೊಂಡಿರುವ ಒಂದು ಉಚಿತ, ತೆರೆದ ಮೂಲ ಸಂಶೋಧನಾ ವೇದಿಕೆಯಾಗಿದೆ. ಇಂದಿನ ವಚನ, ಪದಪುಂಜ ಹುಡುಕಾಟ ಮತ್ತು ಸಂಶೋಧನಾ ಸಾಧನಗಳನ್ನು ಅನ್ವೇಷಿಸಿ.",
      keywords:    "ವಚನ, ವಚನ ಸಾಹಿತ್ಯ, ಕನ್ನಡ ಸಾಹಿತ್ಯ, ವಚನಕಾರರು, ಬಸವಣ್ಣ, ಅಲ್ಲಮ ಪ್ರಭು, ಅಕ್ಕಮಹಾದೇವಿ, ಸಂಶೋಧನೆ, ಪದಪುಂಜ, ಕನ್ನಡ"
    )
    @rand_vachana = DailyVachana.includes(vachana: :vachanakaara).last
    begin
      unless @rand_vachana && @rand_vachana.created_at.to_date == Date.today
        ids = Vachana.where("vachana IS NOT NULL AND vachana != ''").pluck(:id)
        r = Random.new(Date.today.to_time.to_i)
        vachana = Vachana.includes(:vachanakaara).find(ids[r.rand(ids.length)])
        @rand_vachana = DailyVachana.create(vachana_id: vachana.id) if vachana
        @vachana = vachana
      else
        @vachana = @rand_vachana.vachana
      end
    rescue => e
      Rails.logger.error "HomeController#index error: #{e.message}"
      @vachana = @rand_vachana&.vachana if @vachana.nil?
    end
    @stats = site_stats
  end

  def admin_panel
    set_meta_tags(title: "ನಿರ್ವಹಣಾ ಸಲಕರಣೆಗಳು - ವಚನ ಸಂಚಯ")
    @exact_count = WordList.sum('exact_search_count')
    @like_count = WordList.sum('like_search_count')
    @total = @exact_count + @like_count
    @static_pages = static_pages_available? ? StaticPage.order(:slug, :locale) : []
    @pending_feedbacks_count = UserFeedback.pending.count
    @vachanakaaras_count = Vachanakaara.count
    @vachanas_count = Vachana.count

    @va_results = if params[:va_name].present?
      Vachanakaara.name_like(params[:va_name]).order(:name).limit(50)
    else
      Vachanakaara.order(:name).limit(50)
    end

    if params[:vachana_number].present?
      @vachana_number_results = Vachana.includes(:vachanakaara).where(vachanaid: params[:vachana_number].to_i)
    end

    if params[:vachana_text].present?
      @vachana_text_results = Vachana.includes(:vachanakaara).where("vachana LIKE ?", "%#{params[:vachana_text]}%").limit(30)
    end
  end

  def feedbacks
    set_meta_tags(title: "ಬಳಕೆದಾರರ ಪ್ರತಿಕ್ರಿಯೆಗಳು - ವಚನ ಸಂಚಯ")
    @feedbacks = UserFeedback.recent_first.includes(:user, :feedbackable)
    case params[:status]
    when 'pending'  then @feedbacks = @feedbacks.pending
    when 'reviewed' then @feedbacks = @feedbacks.reviewed
    when 'dismissed' then @feedbacks = @feedbacks.dismissed
    end
    @feedbacks = @feedbacks.paginate(page: params[:page], per_page: 50)
  end

  def update_feedback
    @feedback = UserFeedback.find(params[:id])
    if params[:status].in?(%w[reviewed dismissed pending])
      @feedback.update_attributes(status: params[:status])
      flash[:notice] = "ಪ್ರತಿಕ್ರಿಯೆ ಸ್ಥಿತಿಯನ್ನು '#{params[:status]}' ಗೆ ನವೀಕರಿಸಲಾಗಿದೆ."
    else
      flash[:error] = "ಅಮಾನ್ಯ ಸ್ಥಿತಿ."
    end
    redirect_to feedbacks_path(status: params[:return_to] || 'pending')
  end

  def destroy_feedback
    @feedback = UserFeedback.find(params[:id])
    @feedback.destroy
    flash[:notice] = "ಪ್ರತಿಕ್ರಿಯೆಯನ್ನು ಅಳಿಸಲಾಗಿದೆ."
    redirect_to feedbacks_path(status: params[:return_to] || 'pending')
  end

  def about_us
    set_meta_tags(
      title:       "ನಮ್ಮ ಬಗ್ಗೆ - ವಚನ ಸಂಚಯ",
      description: "ವಚನ ಸಂಚಯದ ಹಿನ್ನೆಲೆ, ತಂತ್ರಜ್ಞರ ತಂಡ, ಮಾರ್ಗದರ್ಶಕರು ಮತ್ತು ಪ್ರಸ್ತುತಿ ಹಂತಗಳ ಬಗ್ಗೆ ಇನ್ನಷ್ಟು ತಿಳಿಯಿರಿ."
    )
  end

  def ngram
    set_meta_tags(
      title:       "N-gram ವಿಶ್ಲೇಷಣೆ - ವಚನ ಸಂಚಯ",
      description: "ವಚನಕಾರರ ಕಾಲಮಾನದ ಆಧಾರದಲ್ಲಿ ಪದಗಳ ಬಳಕೆಯ N-gram ವಿಶ್ಲೇಷಣೆ ಮತ್ತು ದೃಶ್ಯೀಕರಣ.",
      keywords:    "n-gram, ಪದ ವಿಶ್ಲೇಷಣೆ, ವಚನ ಸಾಹಿತ್ಯ, ಕನ್ನಡ, ಕಾಲಮಾನ"
    )
    if params[:word].present?
      @word = params[:word].squish
      @keyword = KeyWord.find_by_word(@word)
      if @keyword
        @time_series = KeyWord.ngram_time_series(@keyword.id)
        @vachanakaara_usage = KeyWord.ngram_vachanakaara_usage(@keyword.id)
        @related_words = KeyWord.ngram_related_words(@keyword.id)
      end
    end
  end

  def ngram_data
    word = params[:word].to_s.squish
    keyword = KeyWord.find_by_word(word)
    if keyword
      time_series = KeyWord.ngram_time_series(keyword.id)
      vachanakaara_usage = KeyWord.ngram_vachanakaara_usage(keyword.id)
      related_words = KeyWord.ngram_related_words(keyword.id)

      render json: {
        word: keyword.word,
        total_count: keyword.count,
        time_series: time_series.map { |r| { period: r[0], count: r[1].to_i } },
        vachanakaara_usage: vachanakaara_usage.map { |r| { id: r[0].to_i, name: r[1], count: r[2].to_i } },
        related_words: related_words.map { |r| { id: r[0].to_i, word: r[1], count: r[2].to_i } }
      }
    else
      render json: { error: "ಪದ ಕಂಡುಬಂದಿಲ್ಲ" }, status: :not_found
    end
  end

  def ngram_vachanas
    word = params[:word].to_s.squish
    vachanakaara_id = params[:vachanakaara_id].to_i
    vachanakaara_id = nil if vachanakaara_id <= 0

    keywords = KeyWord.where(word: word)
    if keywords.any?
      vachana_ids = keywords.flat_map(&:all_vachana_ids).uniq
      vachanas = Vachana.where(id: vachana_ids).includes(:vachanakaara)
      vachanas = vachanas.where(vachanakaara_id: vachanakaara_id) if vachanakaara_id

      kw_counts = keywords.each_with_object({}) { |kw, h| kw.vachana_id_count_hash.each { |vid, c| h[vid] = c } }
      sorted = vachanas.sort_by { |v| -kw_counts.fetch(v.id, 0) }.first(50)

      results = sorted.map do |v|
        {
          id: v.id,
          vachanaid: v.vachanaid,
          text: v.vachana,
          vachanakaara_name: v.vachanakaara.try(:name),
          vachanakaara_id: v.vachanakaara_id,
          kw_count: kw_counts.fetch(v.id, 0)
        }
      end

      render json: { vachanas: results, total: vachanas.count }
    else
      render json: { vachanas: [], total: 0 }
    end
  end

  def help
    set_meta_tags(
      title:       "ಸಹಾಯ - ವಚನ ಸಂಚಯ",
      description: "ವಚನ ಸಂಚಯದ ವೈಶಿಷ್ಟ್ಯಗಳು, ಹುಡುಕಾಟ ಮತ್ತು ಸಂಶೋಧನಾ ಸಾಧನಗಳ ಕುರಿತು ಸಹಾಯವನ್ನು ಪಡೆಯಿರಿ."
    )
  end

  def edit_static_page
    @page = StaticPage.find(params[:id])
    set_meta_tags(title: "ಪುಟ ಸಂಪಾದಿಸಿ - #{@page.title} - ವಚನ ಸಂಚಯ")
    render layout: false
  end

  def update_static_page
    @page = StaticPage.find(params[:id])
    if @page.update_attributes(params[:static_page])
      flash[:notice] = "ಪುಟವನ್ನು ಯಶಸ್ವಿಯಾಗಿ ನವೀಕರಿಸಲಾಗಿದೆ."
      redirect_to admin_panel_path
    else
      flash[:error] = "ಪುಟವನ್ನು ನವೀಕರಿಸಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ."
      render :edit_static_page, layout: false
    end
  end

  private

  def static_pages_available?
    ActiveRecord::Base.connection.table_exists?('static_pages') rescue false
  end

  STATS_FILE = Rails.root.join("tmp/site_stats.json")

  def site_stats
    if File.exist?(STATS_FILE)
      JSON.parse(File.read(STATS_FILE)).symbolize_keys
    else
      regenerate_site_stats
    end
  end

  def regenerate_site_stats
    stats = {
      male_poets:      Vachanakaara.where(sex: true).count,
      female_poets:    Vachanakaara.where(sex: false).count,
      total_poets:     Vachanakaara.count,
      total_vachanas:  Vachana.count,
      total_keywords:  KeyWord.count
    }
    File.write(STATS_FILE, stats.to_json)
    stats
  end

end
