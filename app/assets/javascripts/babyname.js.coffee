# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$ ->

    window.App = {}

    App.names = new NameCollection()
    App.mainView = new MainView
        el: $('body')
        collection: App.names
    App.names.fetch({reset: true})

    App.rejectedNames = new NameCollection()
    App.favoriteNames = new NameCollection()
