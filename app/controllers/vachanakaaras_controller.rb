class VachanakaarasController < ApplicationController
 before_filter :authenticate_user_role! , only: [:new, :edit,:create,:update,:destroy]
  def index
  	# @vachanakaaras = Vachanakaara.all
    params[:start_letter] = params[:start_letter] ? params[:start_letter] : "ಅ"
    @vachanakaaras= Vachanakaara.start_letter(params[:start_letter]).paginate(:page => params[:page], :per_page => 20)
    set_meta_tags(
      title:       "#{params[:start_letter]} ಅಕ್ಷರದಿಂದ ಪ್ರಾರಂಭವಾಗುವ ವಚನಕಾರರು - ವಚನ ಸಂಚಯ",
      description: "#{params[:start_letter]} ಅಕ್ಷರದಿಂದ ಪ್ರಾರಂಭವಾಗುವ ವಚನಕಾರರ ಪಟ್ಟಿ. ವಚನ ಸಂಚಯದಲ್ಲಿ 250ಕ್ಕೂ ಹೆಚ್ಚು ವಚನಕಾರರನ್ನು ಅನ್ವೇಷಿಸಿ.",
      keywords:    "#{params[:start_letter]}, ವಚನಕಾರರು, ವಚನ ಸಂಚಯ, ಕನ್ನಡ ಸಾಹಿತ್ಯ"
    )

    respond_to do |format|
      format.html
  format.js # actually means: if the client ask for js -> return file.js
end
end

def show
  @vachanakaara = Vachanakaara.find(params[:id])
  all_vachanas = @vachanakaara.vachanas

  # Calculate letter counts for this vachanakaara
  @vachanakaara_letter_counts = Hash.new(0)
  all_vachanas.pluck(:vachana).compact.each do |v|
    first = v[0]
    @vachanakaara_letter_counts[first] += 1 if first
  end

  @start_letter = params[:start_letter] || "ಅ"

  if @vachanakaara_letter_counts[@start_letter] == 0
    @vachanas = all_vachanas.paginate(:page => params[:page], :per_page => 15)
    @start_letter = nil
    @fallback_to_all = true
  else
    @vachanas = all_vachanas.start_letter(@start_letter).paginate(:page => params[:page], :per_page => 15)
  end

  vachanakaara_desc = @vachanakaara.information.to_s.truncate(160, separator: ' ')
  set_meta_tags(
    title:       "#{@vachanakaara.name} - ವಚನಕಾರರ ಪುಟ - ವಚನ ಸಂಚಯ",
    description: "#{@vachanakaara.name} ಅವರ ವಚನಗಳು ಮತ್ತು ಪರಿಚಯ. #{vachanakaara_desc}",
    keywords:    "#{@vachanakaara.name}, #{@vachanakaara.ankitha_naama}, ವಚನಕಾರರು, ವಚನ ಸಂಚಯ"
  )
  respond_to do |format|
   format.html
   format.js
end
end


def edit
  @vachanakaaras = Vachanakaara.order("name")
  @vachanakaara = Vachanakaara.find params[:id]
end

def update
  @vachanakaara =  Vachanakaara.find params[:id]
  @vachanakaara.update_attributes params[:vachanakaara]
  redirect_to edit_vachanakaara_path @vachanakaara
end

def search_vachanakaara_name
  @vachanakaara = params[:vachanakaara_name].to_s
  @ankitha_naama = params[:ankitha_naama].to_s
  if @vachanakaara.blank? and @ankitha_naama.blank?
    flash[:notice] = "ನೀವು ಯಾವುದೇ ಆಯ್ಕೆ ಮಾಡಿರುವುದಿಲ್ಲ"
    redirect_to :back
  else
    if @vachanakaara.blank?
      @vachanakaaras = Vachanakaara.ankitha_like  @ankitha_naama
    elsif @ankitha_naama.blank?
      @vachanakaaras = Vachanakaara.name_like  @vachanakaara
    else
      @vachanakaaras = Vachanakaara.name_or_ankitha_like  @vachanakaara,@ankitha_naama
    end
  end

end

def download_vachanakaara_csv
  require 'csv'
  @vachanakaaras = Vachanakaara.order("name")
  send_data(
    @vachanakaaras.to_csv,
    :type => 'text/csv',
    :filename => 'KeyWord.csv',
    :disposition => 'attachment'
    )
end

def download_all_vachana_csv
  require 'csv'
  zip = Vachana.download_all
  send_data zip, filename: "vachanakaaras.zip", type: 'application/zip'
end




end
