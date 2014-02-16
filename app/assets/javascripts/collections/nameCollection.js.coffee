
#TODO: requirejs
class window.NameCollection extends Backbone.Collection

    model: Name

    # Anna, this is how you get and set a CoffeeScript
    # constant on a class
    @BASE_URL: 'localhost:5000/names'
    url: NameCollection.BASE_URL

    params:
        'gender': 'any'
        'category': 'any'


    #initialize: ->


    ## Takes a param name and value, updates
    ## the fetch URL accordingly, and resets/fetches
    ## collection.
    updateFilter: (param, value) ->

        @params[param] = value

        # Anna, see http://underscorejs.org/#reduce
        # for underscore reduce implementation
        paramString = _.reduce(
            @params
            (str, val, param) ->
                str + "&#{param}=#{val}"
            '')

        # remove leading '&', replace with '?'
        paramString =
            '?' + paramString.substr(1, paramString.length)

        @url = NameCollection.BASE_URL + paramString

        @fetch({reset: true})

        console.log @url



    ## Take reponse (array of names), and remove those names
    ## that have already been rejected or favorited.
    parse: (res, options) ->
        # TODO: we need to reject on names, not the whole obj
        _.without res, App.rejectedNames.toJSON(), App.favoriteNames.toJSON()

