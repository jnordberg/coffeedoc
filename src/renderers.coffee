fs = require('fs')
path = require('path')
eco = require('eco')
traverse = require('traverse')
highlight = require('highlight').Highlight
showdown = require(__dirname + '/../vendor/showdown').Showdown


class Renderer
    constructor: (outputdir, sources) ->
        this.outputdir = outputdir
        this.sources = sources

    preprocess: (context) ->
        ###
        This method should apply any transformations to module documentation
        before it is passed to the template.
        ###
        return context

    renderIndex: (modules) =>
        eco.render(this.index_template, modules: modules)

    renderModule: (context) =>
        eco.render(this.module_template, context)

    shouldMakeSubdirs: -> true
    moduleFilename: (x) -> x
    finish: ->


class HtmlRenderer extends Renderer
    constructor: (outputdir, sources) ->
        super(outputdir, sources)
        this.module_template = fs.readFileSync(__dirname + '/../resources/html/module.eco', 'utf-8')
        this.index_template = fs.readFileSync(__dirname + '/../resources/html/index.eco', 'utf-8')
        this.base_css = fs.readFileSync(__dirname + '/../resources/html/base.css', 'utf-8')

    preprocess: (context) =>
        ###
        Convert markdown to html, adding syntax highlighting markup to any code
        blocks.
        ###
        context = super(context)
        return traverse(context).map (value) ->
          if value and this.key == 'docstring'
            this.update(highlight(showdown.makeHtml(value), false, true))

    moduleFilename: (x) ->
        return x + '.coffee'

    finish: =>
        ###
        Write CSS files out to resources.
        ###
        resourcesdir = path.join(this.outputdir, 'resources')
        fs.mkdir resourcesdir, '755', =>
            fs.writeFile(path.join(resourcesdir, 'base.css'), this.base_css)
            fs.writeFile(path.join(resourcesdir, 'module.css'), this.module_css)
            fs.writeFile(path.join(resourcesdir, 'index.css'), this.index_css)

    fileExtension: -> '.html'
    indexFile: -> 'index.html'


class GithubWikiRenderer extends Renderer
    constructor: (outputdir, sources) ->
        super(outputdir, sources)
        this.module_template = fs.readFileSync(__dirname + '/../resources/github-wiki/module.eco', 'utf-8')
        this.index_template = fs.readFileSync(__dirname + '/../resources/github-wiki/index.eco', 'utf-8')

    _wikiize: (path) ->
        bits = path.split('/')
        bucket = []
        for b in bits
            if b
                bucket.push "#{b[0].toUpperCase()}#{b.substring 1}"
        return bucket.join(':')

    _quoteMarkdown: (t) ->
        ###
        Its more than possible that a function name will have underscores... quote them.
        ###
        return t.replace(/([^\\])?_/g, "$1\\_")

    _params: (t) ->
        a = []
        for x in t
            if x?
               a.push x
            else
               a.push '{splat}'
        return a.join ', '

    moduleFilename: (x) =>
        return this._wikiize(x)

    preprocess: (context) =>
        context.wikiize = this._wikiize
        context.quoteMarkdown = this._quoteMarkdown
        context.params = this._params
        return context

    fileExtension: -> '.md'
    indexFile: -> 'ModuleIndex.md'
    shouldMakeSubdirs: -> false


class JSONRenderer extends Renderer
    constructor: (outputdir, sources) ->
        this.outputdir = outputdir
        this.sources = sources

    renderIndex: JSON.stringify

    renderModule: JSON.stringify

    shouldMakeSubdirs: -> false
    moduleFilename: (x) -> false # No individual file output
    fileExtension: -> '.doc.json'
    indexFile: -> 'index.doc.json'


exports.html = HtmlRenderer
exports.gfm  = GithubWikiRenderer
exports.json = JSONRenderer
