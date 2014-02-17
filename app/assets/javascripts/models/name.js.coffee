
class window.Name extends Backbone.Model

    defaults:
        name: ''
        origin: ''

    initialize: ->

    parse: (res) ->
        res._id = res._id.$oid
        return res
