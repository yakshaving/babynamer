# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#

$ ->

    window.App = {}

    App.names = new NameCollection [
        {name: 'arya', origin:'sanskrit'}
        {name: 'sansa', origin:'who knows'}
        {name: 'james', origin:'?'}
        {name: 'earl', origin:'?'}
        {name: 'jones', origin:'ha'}
    ]

    App.rejectedNames = new NameCollection()
    App.favoriteNames = new NameCollection()
    App.favoriteNames.on('add', (model, collection) => console.log(collection.toJSON()))
    App.rejectedNames.on('add', (model, collection) => console.log(collection.toJSON()))

    App.mainView = new MainView
        el: $('body')
        collection: App.names
