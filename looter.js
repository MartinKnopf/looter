var Rx = require('rx')
  , moment = require('moment')
  , _ = require('lodash')
  , TICK = 2000;

function sinPrice(min, max, x) { return Math.floor((Math.sin(x) + 1) / 2 * (max - min) + min); }

function randomize(price) { return Math.floor(_.random(price - _.random(900, 3500) / 2, price + _.random(900, 3500) / 2)); }

function time() { return moment().format('DD.MM.YYYY hh:mm:ss'); }

var gameLoop
  = exports.gameLoop
  = Rx.Observable.interval(10)

var timestampSource
  = exports.timestampSource
  = gameLoop
    .map(time)

var sinusTrend
  = gameLoop
    .map(function(time) { return time / 10; })
    .map(_.partial(sinPrice, 900, 3501))

var dot
  = Rx.Observable.zip(
    gameLoop,
    sinusTrend.map(randomize),
    function(x, y) { return {x: x, y: y}; })

var randSinus
  = exports.randSinus
  = dot
    .where(function even(dot) { return dot.x % 2 === 0; })
    .combineLatest(
      dot
        .where(function uneven(dot) { return dot.x % 2 !== 0; }),
      function(prev, curr) {
        return {value: curr.y, dots: {prev: prev, curr: curr}};
      })