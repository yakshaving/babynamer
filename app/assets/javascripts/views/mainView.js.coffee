
#### MainView manages the entire DOM. This will later be split
#### into seperate subviews.
class window.MainView extends Backbone.View


    ## On instantiation of MainView
    initialize: ->
        @$mainBox = $('.main-box')

        @listenTo @collection, 'reset', @_next


    ## Renders a given NameModel
    render: (model) ->
        @$mainBox.html @_template(model.toJSON())




    #### UI Handlers ####

    events:
        'click #pass'     : 'onPassClick'
        'click #favorite' : 'onFavoriteClick'
        'change select'   : 'onFilterChange'


    ## When pass button is clicked, render next.
    onPassClick: (e) =>
        App.rejectedNames.add @collection.shift()
        @_next()


    ## When favorite button is clicked, add model to saved
    ## collection
    onFavoriteClick: (e) =>
        App.favoriteNames.add @collection.shift()
        @_next()


    ## When a Filter is changed, update params.
    onFilterChange: (e) =>
        $el = $(e.target)
        App.names.updateFilter($el.attr('data-param'), $el.val())




    #### Helpers ####

    ## If collection has another card, render it!
    _next: ->
        if !@collection.isEmpty()
            @render(@collection.first())


    ## Compiles JSON to HTML string.
    ## Expects {data: '', origin: ''}, returns string
    _template: (data) ->
        """
        <div class='name'>
            <div class='babyname'>#{data.name}</div>
            <div class='origin'><h2>#{data.origin}</h2></div>
        </div>
        """
        #<div class='meaning'><h2>#{data.meaning}</h2></div>



