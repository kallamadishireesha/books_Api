class BooksController < ApplicationController
    before_action :set_book, only: %i[show update destroy]
  
    def index
      @books = Book.paginate(page: params[:page], per_page: 10)
      render json: {
        current_page: params[:page] || 1,
        total_pages: @books.total_pages,
        total_entries: @books.total_entries,
        books: @books
      }
    end
  
    def show
        if @book
            render json: @book
        else
            render json: { error: "Book not found" }, status: :not_found
        end
    end
  
    def create
      book = Book.new(book_params)
      if book.save
        render json: book, status: :created
      else
        render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      if @book.update(book_params)
        render json: @book
      else
        render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      @book.destroy
      head :no_content
    end
  
    private
  
    def set_book
      @book = Book.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Book not found" }, status: :not_found
    end
  
    def book_params
      params.require(:book).permit(:title, :author)
    end
  end
  