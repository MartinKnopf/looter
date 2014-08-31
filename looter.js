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

  var nextTurn = clickNextTurn
    .select(function(event, idx) { return idx + 1; })
    .take(10)
    .repeat()

  var newPrice = nextTurn
    .map(_.partial(sinPrice, stocks[0].min, stocks[0].max))
    .map(_.partial(randomize, stocks[0].min, stocks[0].max))
    .publish()

  var newBuy = Rx.Observable
    .combineLatest(clickBuy, newPrice, function(event, price) { return {event: event, price: price}; })
    .distinctUntilChanged(function(x) { return x.event; })
    .map(function(x) { return -x.price; })

  var newSell = Rx.Observable
    .combineLatest(clickSell, newPrice, function(event, price) { return {event: event, price: price}; })
    .distinctUntilChanged(function(x) { return x.event; })
    .map(function(x) { return x.price; })

  var balance = Rx.Observable
    .merge(Rx.Observable.return(10000), newBuy, newSell)
    .scan(function(sum, price) { return sum + price; })
    .filter(function(balance) { return balance >= 0; })

  // observers

  nextTurn.subscribe(function(turn) {
    $('.turn-nr').text(turn);
    $('.stock1 .buy').prop('disabled', false);
    $('.stock1 .sell').prop('disabled', false);
  })

  clickBuy.subscribe(function() {
    $('.stock1 .buy').prop('disabled', true);
    $('.stock1 .sell').prop('disabled', true);
  })

  clickSell.subscribe(function() {
    $('.stock1 .sell').prop('disabled', true);
    $('.stock1 .buy').prop('disabled', true);
  })

  newPrice.subscribe(function(price) {
    $('.stock1 .price').text(price);
  })

  balance.subscribe(function(balance) {
    $('.balance').text(balance);
  })

  newPrice.connect()

}(Rx, moment, _))
