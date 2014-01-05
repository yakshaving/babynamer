
#### MainView manages the entire DOM. This will later be split
#### into seperate subviews.
class window.MainView extends Backbone.View


    ## On instantiation of MainView
    initialize: ->
        @$mainBox = $('.main-box')

        # Let's just render the first model.
        @render(@collection.shift())


    ## Renders a given NameModel
    render: (model) ->
        @currentModel = model
        @$mainBox.html @template(model.toJSON())


    events:
        'click #pass' : 'onPassClick'
        # TODO: Add event for favorite click


    ## When pass button is clicked, render next.
    # TODO: understand difference between -> and =>
    onPassClick: (e) =>
        if !@collection.isEmpty()
            @render(@collection.shift())


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


