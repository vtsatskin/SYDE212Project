require './article.rb'
require 'csv'

class ArticleCollector
  def self.random num = 1, lang = "en"
    num.times.map { Article.random lang }
  end

  def self.randomTranslated opt = {}
    opt[:num] ||= 1
    opt[:sourceLang] ||= :en
    opt[:translatedLang] ||= :fr

    collection = {}
    while collection.length < opt[:num]
      original = Article.random opt[:sourceLang]
      translated = original.toLang opt[:translatedLang]
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

  def self.articlePairsToCSV hash, path = nil
    str = CSV.generate do |csv|
      hash.values.each do |pair|
        original = pair[0]
        translated = pair[1]
        wcDiff = original.wordCount - translated.wordCount
        lengthDiff = original.content.length - translated.content.length

        csv << [original.slug, "#{original.language}-#{translated.language}", lengthDiff, wcDiff]
      end
    end

    if path
      File.open(path, 'w') { |f| f.write(str) }
    else
      str
    end
  end
end