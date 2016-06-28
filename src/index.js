'use strict';

require('./styles/main.scss');

var Elm = require( './Main' );

var storedState = localStorage.getItem('elm-clicker-save');
var initialState = storedState ? JSON.parse(storedState) : null;

var app = Elm.Main.embed( document.getElementById( 'main' ), initialState );

app.ports.setStorage.subscribe(function(state) {
    console.log('setting storage');
    localStorage.setItem('elm-clicker-save', JSON.stringify(state));
})
