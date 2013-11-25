require 'open-uri'
require 'json'

# random article locations:
#   en: http://en.wikipedia.org/wiki/Special:Random
#   fr: http://fr.wikipedia.org/wiki/Special:Random

# Represents a Wikipedia article
class Article
  def initialize slugName, language
    @language = language
    @slugName = slugName

    raw = open("http://#{@language}.wikipedia.org/w/api.php?action=query&prop=extracts&titles=#{@slugName}&format=json&explaintext=1").read
    json = JSON.parse(raw)
    @content = json["query"]["pages"].first[1]["extract"]
  end

  def content
    _removeWhitespace(@content)
  end

  def wordCount
    @content.split.length
  end

  private

  def _removeWhitespace string
    string.gsub("\n", ' ').squeeze(' ')
  end
end