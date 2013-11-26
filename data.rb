require './article.rb'
require 'csv'

class ArticleCollector
  def self.random num = 1, lang = "en"
    num.times.map { Article.random lang }
  end

  def self.randomTranslated num = 1, originalLang = "en", translatedLang = "fr"
    collection = {}
    while collection.length < num
      original = Article.random originalLang
      translated = original.toLang translatedLang
      collection[original.slug] = [original, translated] if translated
    end
    collection
  end
end

class MetadataExporter
  def self.articlesToCSV arr, path = nil
    str = CSV.generate do |csv|
      arr.each do |a|
        csv << [a.slug, a.language, a.content.length, a.wordCount]
      end
    end

    if path
      File.open(path, 'w') { |f| f.write(str) }
    else
      str
    end
  end
end