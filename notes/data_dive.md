What is provided
----------------

- Commented code for scraping
- Uncleaned dataset but...
- Commented code for partial cleaning of data
- Example code for analysis (with links to tutorials-blog posts)
	- Plotting of geographic distribution of signatures
	- Number of signatures by category of petition
	- A negative binomial regression model
- Niklas' PetitionPaper

What people could do
--------------------

- Scrape further data
- Complete data cleaning
- Analysis the data
- Plot the data

What we should scrape beforehand
--------------------------------

- List of petitions including
	- Name of petitions
	- Petitioner
	- Adressee of petition
	- Region
	- Topic
	- Status
	- Number of supporters
	- Petition text

(we should be able to get these via XML)

Collecting the above requires reading all pages of https://www.openpetition.de/liste/closed. Putting this in a list.
This gives us the name of the petition and link to petition page.
We then need to access all petition pages and scrape the remaining variables.

Next step would be to obtain list of petitioners for each petition.

So basically there are two units of analysis emerging fro the data collection. The petition and the signature, the latter being nested into petitions. Of course aggregation in the analysis phase can create different units of analysis.


