class ReferenceBooksController < ApplicationController
  before_filter :authenticate_user_role! 
  def index 
    @reference_books = ReferenceBook.all
  end
  def new
    @reference_book = ReferenceBook.new
  end
  def create
    @reference_book = ReferenceBook.new(params[:reference_book])
    if @reference_book.save
      redirect_to reference_books_path
      flash[:notice] = "Reference creation succesfull"
    else
      flash[:error] = "Please fill required fields"
      render "new"
    end
  end

  def destroy
    @reference_book = ReferenceBook.find(params[:id])
    @reference_book.destroy
    redirect_to reference_books_path
    flash[:notice] = "succesfullly deleted"
  end

end
