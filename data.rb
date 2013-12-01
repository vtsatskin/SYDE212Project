require './article.rb'
require 'csv'

class ArticleCollector
  def self.random num = 1, lang = "en"
    i = 0
    num.times.map { puts "Generating #{i} article"; i += 1; Article.random lang; }
  end

  def self.randomTranslated opt = {}
    opt[:num] ||= 1
    opt[:sourceLang] ||= :en
    opt[:translatedLang] ||= :fr

    collection = {}
    while collection.length < opt[:num]
      original = Article.random opt[:sourceLang]
      translated = original.toLang opt[:translatedLang]
      if translated
        collection[original.slug] = [original, translated]
        puts "Found #{collection.length} articles"
      end
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

        csv << [original.slug, "#{original.language}-#{translated.language}", original.content.length, original.wordCount,  translated.content.length, translated.wordCount]
      end
    end

    if path
      File.open(path, 'w') { |f| f.write(str) }
    else
      str
    end
  end
end