require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def index
    reset_session  # Réinitialiser la session à chaque visite de l'index
  end

  def new
    alphabet = ('A'..'Z').to_a
    @letters = Array.new(10) { alphabet.sample }
    session[:total_score] ||= 0
  end

  def score
    @word_found = params[:word].upcase
    @letters = params[:letters].split(" ")
    @grid_to_show = params[:letters]
    url_api = "https://dictionary.lewagon.com/#{@word_found}"
    word_check = URI.open(url_api).read
    word = JSON.parse(word_check)
    @is_english = word["found"]

    @included = included?(@word_found, @letters)

    if @included && @is_english
      session[:total_score] += @word_found.length
    end
  end

  private

  def included?(word, letters)
    word_letters = word.split('')  # Convertit le mot en un tableau de caractères
    word_letters.each do |letter|
      if word_letters.count(letter) > letters.count(letter)
        return false  # Retourne false dès que l'une des lettres est trop présente
      end
    end
    true  # Retourne true si toutes les lettres sont correctement présentes
  end
end
