CoffeeDoc
=========

An API documentation generator for CoffeeScript
-----------------------------------------------

CoffeeDoc is a simple API documentation generator for [CoffeeScript][]. It reads
python-style docstrings in your CoffeeScript class and function definitions,
passes them through [Markdown][] and outputs the result as easy to read HTML.

Thanks to [apgwoz](https://github.com/apgwoz), CoffeeDoc can also generate [wiki
pages for Github](https://github.com/apgwoz/coffeedoc-hub/wiki/Src:Coffeedoc)!

CoffeeDoc can also return your documentation as JSON, so you can run it through
an external documentation system such as [Sphinx][].

CoffeeDoc is inspired by the excellent [Docco][], and is intended for projects
that require more structured API documentation.

The docstring convention CoffeeDoc uses is inspired by Python, and looks like
this:

```coffeescript
###
# CoffeeDoc example documentation #

This is a module-level docstring, and will be displayed at the top of the module documentation.
Documentation generated by [CoffeeDoc](http://github.com/omarkhan/coffeedoc)
###

class MyClass extends Superclass
    ###
    This docstring documents MyClass. It can include *Markdown* syntax,
    which will be converted to html.
    ###
    constructor: (@args) ->
        ### Constructor documentation goes here. ###

    method: (args) ->
        ### This is a method of MyClass ###

myFunc = (arg1, arg2, args...) ->
    ###
    This function will be documented by CoffeeDoc
    ###
    doSomething()
```

The documentation generated from the above script can be seen
[here](http://omarkhan.github.com/coffeedoc/test/example.coffee.html). For a
more interesting example, here is [the result of running coffeedoc against
`src/coffeedoc.coffee`](http://omarkhan.github.com/coffeedoc/src/coffeedoc.coffee.html).

### Installation ###

CoffeeDoc requires [Node.js][], [CoffeeScript][], [eco][], and [optimist][].
Install using npm with the following command:

    sudo npm install -g coffeedoc

The -g option installs CoffeeDoc globally, adding the coffeedoc executable to
your PATH. If you would rather install locally, omit the -g option.

You can also install from source using cake. From the source directory, run:

    sudo cake install

### Usage ###

CoffeeDoc can be run from the command line:

    Usage: coffeedoc [options] [targets]

    Options:
      --output, -o      Set output directory                                            [default: "docs"]
      --ignore, -i      Files or directories to ignore
      --stdout          Direct all output to stdout instead of files
      --hide-private    Do not document methods beginning with an underscore
      --parser          Parser to use. Built-in parsers: commonjs, requirejs            [default: "commonjs"]
      --renderer        Renderer to use. Built-in renderers: html, gfm, json            [default: "html"]
      --indexTemplate   Override the default index template for the selected renderer
      --moduleTemplate  Override the default module template for the selected renderer
      --help, -h        Show this help and exit

If [targets] is a directory, CoffeeDoc will recursively document all `.coffee`
files found under that directory.

If you wish to document several modules, make sure you generate all
the docs with a single command -- this ensures that they will all appear in the
`index.html` file.

#### Note on Markdown headers ####

Markdown uses `#` characters for headers, e.g.

    # Header 1
    ## Header 2
    ### Header 3
    #### Header 4
    ##### Header 5
    ###### Header 6

As using a sequence of 3 or more `#` characters within a CoffeeScript block
comment would end the comment block, CoffeeDoc allows for the `\#` escape
sequence in docstrings. So instead of `### Header`, use `\#\#\# Header` or
`##\# Header`. Ugly, but it works.

### How it works ###

CoffeeDoc uses the CoffeeScript parser to generate a parse tree for the given
source files. It then extracts the relevant information from the parse tree:
class and function names, class member functions, function argument lists and
docstrings.

Docstrings are defined as the first herecomment block following the class or
function definition. Note that regular single line comments will be ignored.

The resulting documentation information is then passed to an [eco][] template
to generate the html output.

### TODO ###

- Doctests

### Alternatives ###

- [Docco][] for literate programming style docs.
- [Codo][] for something more ruby than python.

### Licence ###

CoffeeDoc is © 2012 Omar Khan, released under the MIT licence. Use it, fork it.

[CoffeeScript]: http://jashkenas.github.com/coffee-script/
[Sphinx]: http://sphinx.pocoo.org/
[Docco]: http://jashkenas.github.com/docco/
[Node.js]: http://nodejs.org/
[eco]: http://github.com/sstephenson/eco
[optimist]: http://github.com/substack/node-optimist
[Markdown]: http://daringfireball.net/projects/markdown/
[Codo]: http://github.com/netzpirat/codo
