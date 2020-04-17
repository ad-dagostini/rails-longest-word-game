class GamesController < ActionController::Base
  require 'open-uri'
  require 'json'

  def new
    @letters = random_letter(10)
  end

  def score
    @word = params[:word]
    grid = params[:letters].split('')
    @result = @word
    @result = @letters
    check_word_letters = check_word(@word, grid)
    if check_word_letters == true
      if check_api(@word.downcase)['found'] == false
        @result = "Sorry #{@word.upcase} but does is not a valid English word."
      else
        @result = "Congratulations! #{@word.upcase} is a valid English word!"
      end
    else
      @result = "Sorry but #{@word.upcase} can't be built of #{grid.join}"
    end
  end

  private

  def random_letter(num)
    letters_array = Array('A'..'Z')
    Array.new(num) { letters_array.sample }
  end

  def check_word(word, grid)
    word.upcase.split('').all? do |letter|
      check = grid.include?(letter.upcase)
      check == true ? grid.delete_at(grid.index(letter)) : false
      check
    end
  end

  def check_api(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    open_url = open(url).read
    result = JSON.parse(open_url)
    result
  end
end
