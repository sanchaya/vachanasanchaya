class HomeController < ApplicationController
  before_filter :authenticate_user_role! , only: [:admin_panel, :feedbacks, :update_feedback]
  
  def index
    set_meta_tags(
      title:       "ವಚನ ಸಂಚಯ - ವಚನ ಸಾಹಿತ್ಯ ಸಂಶೋಧನೆ ಮತ್ತು ಅಧ್ಯಯನ ತಾಣ",
      description: "ವಚನ ಸಂಚಯವು ೨೫,೦೦೦ಕ್ಕೂ ಹೆಚ್ಚು ವಚನಗಳನ್ನು ಮತ್ತು ೨೫೦ಕ್ಕೂ ಹೆಚ್ಚು ವಚನಕಾರರನ್ನು ಒಳಗೊಂಡಿರುವ ಒಂದು ಉಚಿತ, ತೆರೆದ ಮೂಲ ಸಂಶೋಧನಾ ವೇದಿಕೆಯಾಗಿದೆ. ಇಂದಿನ ವಚನ, ಪದಪುಂಜ ಹುಡುಕಾಟ ಮತ್ತು ಸಂಶೋಧನಾ ಸಾಧನಗಳನ್ನು ಅನ್ವೇಷಿಸಿ.",
      keywords:    "ವಚನ, ವಚನ ಸಾಹಿತ್ಯ, ಕನ್ನಡ ಸಾಹಿತ್ಯ, ವಚನಕಾರರು, ಬಸವಣ್ಣ, ಅಲ್ಲಮ ಪ್ರಭು, ಅಕ್ಕಮಹಾದೇವಿ, ಸಂಶೋಧನೆ, ಪದಪುಂಜ, ಕನ್ನಡ"
    )
    @rand_vachana = DailyVachana.last
    begin
      unless @rand_vachana && @rand_vachana.created_at.to_date == Date.today
        vachana = Vachana.where("vachana IS NOT NULL AND vachana != ''").order("RAND()").first
        @rand_vachana = DailyVachana.create(vachana_id: vachana.id) if vachana
      end
    rescue => e
      Rails.logger.error "HomeController#index error: #{e.message}"
    end
    @vachana = @rand_vachana&.vachana
  end

  def admin_panel
    set_meta_tags(title: "ನಿರ್ವಹಣಾ ಸಲಕರಣೆಗಳು - ವಚನ ಸಂಚಯ")
    @exact_count = WordList.sum('exact_search_count')
    @like_count = WordList.sum('like_search_count')
    @total = @exact_count + @like_count
    @static_pages = static_pages_available? ? StaticPage.order(:slug, :locale) : []
    @pending_feedbacks_count = UserFeedback.pending.count
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

end
