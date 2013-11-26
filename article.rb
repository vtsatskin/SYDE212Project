require 'open-uri'
require 'json'

# Represents a Wikipedia article
class Article
  attr_accessor :language, :slug

  def self.random language
    uri = open("http://#{language}.wikipedia.org/wiki/Special:Random").base_uri
    title = uri.to_s.split("/").last

    self.new :title => title, :lang => language
  end

  def initialize opt = {}
    @language = opt[:lang] || :en
    @slug = (opt[:title] && URI.encode(opt[:title])) || opt[:slug]

    raw = open("http://#{@language}.wikipedia.org/w/api.php?action=query&prop=extracts%7Clanglinks&titles=#{@slug}&format=json&explaintext=1&llurl=true&lllimit=500").read
    json = JSON.parse(raw)
    @content = json["query"]["pages"].first[1]["extract"]

    langLinks = json["query"]["pages"].first[1]["langlinks"]
    langLinks ||= []
    @languageMap = Hash[langLinks.map { |h| [h["lang"].to_sym, h["url"].split('/').last] }]
  end

  def content
    @content ||= ""
    _removeWhitespace(@content)
  end

  def wordCount
    @content.split.length
  end

  def toLang language
    if @languageMap[language]
      self.class.new :slug => @languageMap[language], :lang => language
    end
  end

  def ==(other)
    @slug == other.slug && @language == other.language
  end

  private

  def _removeWhitespace string
    string.gsub("\n", ' ').squeeze(' ')
  end
end