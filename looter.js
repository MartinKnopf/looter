(function(Rx, moment, _) {

  var stocks = [{
    min: 900,
    max: 3500
  }];

  // private helper functions

  function sinPrice(min, max, x) { return Math.floor((Math.sin(x) + 1) / 2 * (max + 1 - min) + min); }

  function randomize(min, max, price) { return Math.floor(_.random(price - _.random(min, max) / 2, price + _.random(min, max) / 2)); }

  // observables

  var clickNextTurn = Rx.Observable.fromEvent($('.next-turn'), 'click')
    , clickBuy = Rx.Observable.fromEvent($('.stock1 .buy'), 'click')
    , clickSell = Rx.Observable.fromEvent($('.stock1 .sell'), 'click')

  var turns = Rx.Observable
    .merge(clickNextTurn, clickBuy, clickSell)
    .select(function(event, idx) { return idx + 1; })
    .take(10)
    .repeat()

  var randSinus = turns
    .map(_.partial(sinPrice, stocks[0].min, stocks[0].max))
    .map(_.partial(randomize, stocks[0].min, stocks[0].max))
    .publish()

  var balance = Rx.Observable
    .return(10000)
  balance = clickBuy
    .map(function(b, e, r, l) {
        return ;
      })
    .startWith(10000)

  // observers

  turns.subscribe(function(turn) {
    $('.turn-nr').text(turn);
  })

  clickBuy.subscribe(function() {
    $('.stock1 .buy').prop('disabled', true);
    $('.stock1 .sell').prop('disabled', false);
  })

  clickSell.subscribe(function() {
    $('.stock1 .sell').prop('disabled', true);
    $('.stock1 .buy').prop('disabled', false);
  })

  randSinus.subscribe(function(price) {
    $('.stock1 .price').text(price);
  })

  balance.subscribe(function(balance) {
    $('.balance').text(balance);
  })

  randSinus.connect()

}(Rx, moment, _))
