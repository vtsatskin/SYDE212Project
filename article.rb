require 'open-uri'
require 'json'
require 'nokogiri'

# Represents a Wikipedia article
class Article
  attr_accessor :language, :slug

  def self.random language
    uri = open("http://#{language}.wikipedia.org/wiki/Special:Random").base_uri
    title = uri.to_s.split("/").last

    self.new title, language
  end

  def initialize title, language
    @language = language
    @slug = URI::encode(title)

    raw = open("http://#{@language}.wikipedia.org/w/api.php?action=query&prop=extracts&titles=#{@slug}&format=json&explaintext=1").read
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
    title = @languageMap[language].split("/").last
    Article.new title, language
  end

  def ==(other)
    @slug == other.slug && @language == other.language
  end

  private

  def _removeWhitespace string
    string.gsub("\n", ' ').squeeze(' ')
  end

  def _languageLinks
    doc = Nokogiri::HTML(open("http://#{@language}.wikipedia.org/wiki/#{@slug}"))
    links = doc.css("#p-lang ul a")
    Hash[links.map { |a| [a.attribute("lang").to_s, "http:" + a.attribute("href").value] }]
  end
end