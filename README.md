SYDE212Project
==============

## Requirements

* Ruby
* Bundler

## Installation

	bundle install

## Usage

Fetches a particular article, must supply a full article name (case sensitive) and language:

	Article.new "Bill Gates", "en"

Fetches a random article (a language must be supplied):

	Article.random "fr"

Checking an article's metadata:

	a = Article.random "en"
	a.content.length # letter count
	a.wordCount # word count

Fetching a batch of articles:

	ArticleCollector.random 20, "en"

Exporting a batch of articles to a CSV string:

	articles = ArticleCollector.random 20, "en"
	MetadataExporter.articlesToCSV articles

Or to a file:

	MetadataExporter.articlesToCSV articles, pathToFile

The format of the CSV is as follows:

	#name,language,letterCount,wordCount
	Carol_Cass,en,903,143
	DeCanio,en,50,8
	Hamworthy,en,2985,492
	...
