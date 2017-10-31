'use strict';

// require('ace-css/css/ace.css');
// require('font-awesome/css/font-awesome.css');

// require('@webcomponents/webcomponentsjs/webcomponents-lite.js');
// require('webcomponents.js/webcomponents-lite.min.js');
// require('google-map/google-map.html');
var api = require('./apikey.js');
var s = document.createElement('script');
s.setAttribute('src','https://maps.googleapis.com/maps/api/js?key=%s'.replace('%s',api.googleMapKey))
// document.getElementById('source').appendChild(s);

// Require index.html so it gets copied to dist
require('./index.html');

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

// .embed() can take an optional second argument. This would be an object describing the data we need to start a program, i.e. a userID or some token
var app = Elm.Main.embed(mountNode);

app.ports.loadMap.subscribe(function(model) {
  var mapDiv = document.getElementsByTagName('google-map')[0];
  var myLatlng = new google.maps.LatLng(model.lat, model.lng);
  var mapOptions = {
    zoom: 8,
    center: myLatlng
  };
  var gmap = new google.maps.Map(mapDiv, mapOptions);
  app.ports.receiveMap.send(gmap);
});
