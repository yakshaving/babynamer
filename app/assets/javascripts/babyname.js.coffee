# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$ ->

    App = {}

    names = new NameCollection [
        {name: 'arya', origin:'sanskrit'},
        {name: 'sansa', origin:'who knows'},
        {name: 'james', origin:'?'},
        {name: 'earl', origin:'?'},
        {name: 'jones', origin:'ha'}
    ]

    App.mainView = new MainView
        el: $('body')
        collection: names
