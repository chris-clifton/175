require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @table_of_contents = File.readlines("data/toc.txt")
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map do |line, index|
      "<p id=paragraph#{index}>#{line}</p>"
    end.join
  end

  def highlight(text, term)
    text.gsub(term, %(<strong>#{term}</strong>))
  end
end


get "/" do
  @title = "THE LETTERS"
  
  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  @chapter_name = @table_of_contents[number - 1]
  
  redirect "/" unless (1..@table_of_contents.size).cover?(number)
  
  @title = "Chapter #{number}: #{@chapter_name}"
  @chapter = File.read("data/chp#{number}.txt")
    
  erb :chapter
end

get "/search" do
  @title = "SEARCH"
  @results = chapters_matching(params[:query]) 

  erb :search
end

not_found do
  redirect "/"
end

# Calls block for each chapter, passing chapter's number, name, and contents
def each_chapter
  @table_of_contents.each_with_index do |name, index|
  number = index + 1
  contents = File.read("data/chp#{number}.txt")
  yield number, name, contents
  end
end

# Returns array of Hashes representing chapters that match the specified query.
# Each hash contains values for its :name and :number keys
# The value for :paragraphs will be a hash of paragraph indexes and that paragraphs text
def chapters_matching(query)
  results = []
  return results unless query

  each_chapter do |number, name, contents|
    matches = {}
    contents.split("\n\n").each_with_index do |paragraph, index|
      matches[index] = paragraph if paragraph.include?(query)
    end
    results << {number: number, name: name, paragraphs: matches} if matches.any?
  end
  results
end