#Basic Sales Tax Problem
##Introduction

This is an implementation for Basic sales tax problem in **Elixir** using *Functional Design*.

###Building and Running
The code uses Mix build system and unit test cases are written in ExUnit. The following commands can be used in terminal/command line after [installing Elixir](https://elixir-lang.org/install.html).

To compile the code:

	mix compile

To run ExUnit test cases

	mix test

To build escript which is an executable that can be used to run this app on any machine that has Erlang

	mix escript.build

To run the executable provide the input as a file. A sample input files are already included under priv directory and can be executed  as given below

	./sales_tax --path=priv/input3.txt

if you wish to use other directory for input files please provide the absolute path. 	

Sample file: input3.txt

	Quantity, Product, Price
	1, imported bottle of perfume, 27.99
	1, bottle of perfume, 18.99
	1, packet of headache pills, 9.75
	1, imported box of chocolates, 11.25

Sample output file: input3_output.txt , Output file is generated under same directory as that of input file and displayed on the console as well.

	1, imported bottle of perfume, 32.19
	1, bottle of perfume, 20.89
	1, packet of headache pills, 9.75
	1, imported box of chocolates, 11.85

	Sales Taxes: 6.70
	Total: 74.68

##Assumptions

* The *Price* in input file is price of a single unit of line item.
* For cash rounding the sales tax to 5 cent, the ceil value is taken.
* Inputs are from the text files and is expected to be in the format provided as samples under priv directory.
* Products with the keyword "imported" will be identified as imported goods and the tax amount will be calculated accordingly.
* Exempted products are identified based on pre-defined keywords.  

##Implementation

The whole process has been divided into 3 problems.

1. Parsing the input  (*receipt_parser.ex*)
2. Calculating tax for each item (*tax_calculator.ex*)
3. Calculating total tax and generating invoice (*shopping_basket.ex*)
4. Writing the invoice to file (*file_writer.ex*)



###Money matters
> I've tried "keeping it real" but then I found "things just don't add up". #IEEE754Joke - [Someone on twitter](https://twitter.com/chrisoldwood/status/632104876705730560)

The *money.ex* is a very simple implementation of Money Pattern of [Martin Fowler](https://martinfowler.com/eaaCatalog/money.html). All monetory values in the application like item price, sales tax etc. are stored using this Money module in *money.ex*.

The *cash_rounding* method in *Money* module is used to round the sales tax to nearest 5 cent.

###Config
The exempted items and the tax slabs are kept in *config/config.exs*.

	config :sales_tax,
	exempted: ["pill", "chocolate", "book"],
	basic_tax_rate: 10,
	imported_tax_rate: 5
Any changes in slabs or exemption keywords can be made here.

###Future enhancements

* As this being as simple command line app, the power of Elixir's concurrency hasn't been used much in this project. Future implementations can be made to run concurrently using functionalities of OTP.

* Any new taxes like VAT, GST can be easily added to the existing implementation to the *TaxCalculator* module.
* As the computations are very simple, a very basic *Money* module has been implemented. But for complex logic & support for different currencies the *Money* module has to be updated to provide i18n support or packages like [Money](https://hex.pm/packages/money/) can be used after carefully testing it.
* Can be updated to MVC pattern / Rest API using Phoenix framework and get rid of usage of input and output files and use JSON,

###Code Style and Formatting

Used latest Elixir 1.6 option for auto formatting , [Autoformatting](https://hashrocket.com/blog/posts/format-your-elixir-code-now)

	mix format lib/path/to/file.ex

And [credo](https://hex.pm/packages/credo) for static code analysis

###References
Since this is my first week with Elixir, this could not have been achieved without the following :)

* [The Elixir Language](https://elixir-lang.org)
* [Getting started with Elixir - the PluralSight course](https://app.pluralsight.com/courses/elixir-getting-started)
* [The Money Package](https://github.com/liuggio/money)
* [The Elixir Style guide](https://github.com/christopheradams/elixir_style_guide)
