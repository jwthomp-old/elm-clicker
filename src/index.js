'use strict';

require('./styles/main.scss');

var Elm = require( './Main' );

var storedState = localStorage.getItem('elm-clicker-save');
var initialState = storedState ? JSON.parse(storedState) : null;

// Just passing up the JSON string to be interpreted by Elm
var app = Elm.Main.embed( document.getElementById( 'main' ), storedState );

app.ports.setStorage.subscribe(function(state) {
  console.log('setting storage');
  console.log(state);
  localStorage.setItem('elm-clicker-save', state);
})
