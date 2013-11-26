SYDE212Project
==============

## Requirements

* Ruby
* Bundler

## Installation

	bundle install

## Usage

### Fetching an Article
Fetches a particular article, must supply a full article name (case sensitive) and language:

	Article.new "Bill Gates", "en"

Fetches a random article:

	Article.random :lang => :fr

### Working with an Article
Checking an article's metadata:

	a = Article.random :lang => :en
	a.content.length # letter count
	a.wordCount # word count

### Fetching a batch of articles
Fetching a batch of articles:

	ArticleCollector.random :num => :20, :lang => :en

Fetching a batch of articles:

	ArticleCollector.random :num => :20, :lang => :en

### Exporting

Exporting a batch of articles to a CSV string:

	articles = ArticleCollector.random :num => 50, :lang => :ru
	MetadataExporter.articlesToCSV articles

Or to a file:

	MetadataExporter.articlesToCSV articles, pathToFile

The format of the CSV is as follows:

	#name,language,letterCount,wordCount
	Carol_Cass,en,903,143
	DeCanio,en,50,8
	Hamworthy,en,2985,492
	...
