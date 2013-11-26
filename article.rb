require 'open-uri'
require 'json'
require 'nokogiri'

# Represents a Wikipedia article
class Article

  def self.random language
    raw = open("http://#{language}.wikipedia.org/w/api.php?action=query&list=random&rnnamespace=0&format=json").read
    json = JSON.parse(raw)
    title = json["query"]["random"].first["title"]

    self.new title, language
  end

  def initialize title, language
    @language = language
    @slugName = URI::encode(title)

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

  def toLang language
    @languageMap ||= _languageLinks
    @languageMap[language]
  end

  private

  def _removeWhitespace string
    string.gsub("\n", ' ').squeeze(' ')
  end

  def _languageLinks
    doc = Nokogiri::HTML(open("http://#{@language}.wikipedia.org/wiki/#{@slugName}"))
    links = doc.css("#p-lang ul a")
    Hash[links.map { |a| [a.attribute("lang").to_s, "http:" + a.attribute("href").value] }]
  end
end