(function(Rx, moment, _) {

  var stocks = [{
    min: 900,
    max: 3500
  }];

  // private helper functions
  function sinPrice(min, max, x) { return Math.floor((Math.sin(x) + 1.4) * (max + 1 - min) + min); }
  function randomize(min, max, price) { return Math.floor(_.random(price - _.random(min, max) / 2, price + _.random(min, max) / 2)); }

  // ui observables
  var clickStartGame = Rx.Observable.fromEvent($('.start-new-game'), 'click')
    , clickNextTurn = Rx.Observable.fromEvent($('.next-turn'), 'click')
    , clickBuy = Rx.Observable.fromEvent($('.stock1 .buy'), 'click')
    , clickSell = Rx.Observable.fromEvent($('.stock1 .sell'), 'click')

  // all observables
  var nextTurn, newPrice, newBuy, newSell, newStockAmount, balance, canBuy, cannotBuy, canSell, cannotSell

  function initGameRules() {

    nextTurn = clickNextTurn
      .select(function(event, idx) { return idx + 1; })
      .take(10)
      .repeat()

    newPrice = nextTurn
      .map(_.partial(sinPrice, stocks[0].min, stocks[0].max))
      .map(_.partial(randomize, stocks[0].min, stocks[0].max))
      .publish()

    newBuy = Rx.Observable
      .combineLatest(clickBuy, newPrice, function(event, price) { return {event: event, price: price}; })
      .distinctUntilChanged(function(x) { return x.event; })
      .map(function(x) { return -x.price; })

    newSell = Rx.Observable
      .combineLatest(clickSell, newPrice, function(event, price) { return {event: event, price: price}; })
      .distinctUntilChanged(function(x) { return x.event; })
      .map(function(x) { return x.price; })

    newStockAmount = newBuy
      .map(function() { return 1; })
      .merge(newSell.map(function() { return -1; }))
      .scan(0, function(acc, x) { return acc + x; })

    balance = Rx.Observable
      .merge(Rx.Observable.return(10000), newBuy, newSell)
      .scan(function(sum, price) { return sum + price; })

    canBuy = Rx.Observable
      .combineLatest(balance, newPrice, function(balance, price) { return {balance: balance, price: price}; })
      .filter(function(x) { return x.balance >= x.price; })

    cannotBuy = Rx.Observable
      .combineLatest(balance, newPrice, function(balance, price) { return {balance: balance, price: price}; })
      .filter(function(x) { return x.balance < x.price; })

    canSell = newStockAmount
      .filter(function(amount) { return amount > 0; })

    cannotSell = newStockAmount
      .filter(function(amount) { return amount <= 0; })

    // observers

    nextTurn.subscribe(function(turn) {
      $('.turn-nr').text(turn);
    })

    newPrice.subscribe(function(price) {
      $('.stock1 .price').text(price);
    })

    balance.subscribe(function(balance) {
      $('.balance').text(balance);
    })

    canBuy.subscribe(function(price) {
      $('.stock1 .buy').prop('disabled', false);
    })

    cannotBuy.subscribe(function(price) {
      $('.stock1 .buy').prop('disabled', true);
    })

    canSell.subscribe(function(price) {
      $('.stock1 .sell').prop('disabled', false);
    })

    cannotSell.subscribe(function(price) {
      $('.stock1 .sell').prop('disabled', true);
    })

    newBuy.subscribe(function(price) {
      $('.stock1 .sell').prop('disabled', false);
    })

    newStockAmount.subscribe(function(amount) {
      $('.stock1 .amount').text(amount);
    })

    newPrice.connect()
  }

  clickStartGame.subscribe(function() {

    // reset ui
    
    $('.turn-nr').text('')
    $('.stock1 .price').text('')

    initGameRules();
  
  })

}(Rx, moment, _))
