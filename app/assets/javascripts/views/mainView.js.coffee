
#### MainView manages the entire DOM. This will later be split
#### into seperate subviews.
class window.MainView extends Backbone.View


    ## On instantiation of MainView
    initialize: ->
        @$mainBox = $('.main-box')

        # Let's just render the first model.
        @render(@collection.first())


    ## Renders a given NameModel
    render: (model) ->
        @$mainBox.html @template(model.toJSON())


    events:
        'click #pass'     : 'onPassClick'
        'click #favorite' : 'onFavoriteClick'
        'change select'   : 'onFilterChange'


    ## When pass button is clicked, render next.
    onPassClick: (e) =>
        App.rejectedNames.add @collection.shift()

        if !@collection.isEmpty()
            @render(@collection.first())


    ## When favorite button is clicked, add model to saved
    ## collection
    onFavoriteClick: (e) =>
        App.favoriteNames.add @collection.shift()

        if !@collection.isEmpty()
            @render(@collection.first())


    onFilterChange: (e) =>
        $el = $(e.target)
        App.names.updateFilter($el.attr('data-param'), $el.val())


    ## Compiles JSON to HTML string.
    ## Expects {data: '', origin: ''}, returns string
    template: (data) ->
        """
        <div class='name'>
            <div class='babyname'>#{data.name}</div>
            <div class='origin'><h2>#{data.origin}</h2></div>
        </div>
        """
        #<div class='meaning'><h2>#{data.meaning}</h2></div>


