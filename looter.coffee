stocks = [{
  min: 900,
  max: 3500
}]

sinPrice = (min, max, x) -> Math.floor((Math.sin(x) + 1.4) * (max + 1 - min) + min)
randomize = (min, max, price) -> Math.floor(_.random(price - _.random(min, max) / 2, price + _.random(min, max) / 2))
resetUi = ->
  $('.turn-nr').text('')
  $('.stock1 .price').text('')

clickStartGame  = Rx.Observable.fromEvent($('.start-new-game'), 'click')
clickNextTurn   = Rx.Observable.fromEvent($('.next-turn'), 'click')
clickBuy        = Rx.Observable.fromEvent($('.stock1 .buy'), 'click')
clickSell       = Rx.Observable.fromEvent($('.stock1 .sell'), 'click')

newTurn = clickNextTurn
  .select((event, idx) -> idx + 1)
  .take(10)
  .merge(clickStartGame.map(_.constant(0)))

newPrice = newTurn
  .filter((x) -> x != 0 )
  .map(_.partial(sinPrice, stocks[0].min, stocks[0].max))
  .map(_.partial(randomize, stocks[0].min, stocks[0].max))
  .publish()

newBuy = Rx.Observable
  .combineLatest(clickBuy, newPrice, (event, price) -> {event: event, price: price})
  .distinctUntilChanged((x) -> x.event)
  .map((x) -> -x.price)

newSell = Rx.Observable
  .combineLatest(clickSell, newPrice, (event, price) -> {event: event, price: price})
  .distinctUntilChanged((x) -> x.event)
  .map((x) -> x.price)

newStockAmount = newBuy
  .map(() -> 1 )
  .merge(newSell.map(() -> -1 ))
  .scan(0, (acc, x) -> acc + x)
  .merge(clickStartGame.map(_.constant(0)))

balance = Rx.Observable
  .merge(newBuy, newSell)
  .scan((sum, price) -> sum + price)
  .merge(clickStartGame.map(_.constant(10000)))

canBuy = Rx.Observable
  .combineLatest(balance, newPrice, (balance, price) -> {balance: balance, price: price})
  .filter((x) -> x.balance >= x.price)

cannotBuy = Rx.Observable
  .combineLatest(balance, newPrice, (balance, price) -> {balance: balance, price: price})
  .filter((x) -> x.balance < x.price)
  .merge(clickStartGame)

canSell = newStockAmount
  .filter((amount) -> amount > 0)

cannotSell = newStockAmount
  .filter((amount) -> amount <= 0)
  .merge(clickStartGame)

clickStartGame.subscribe(resetUi)

newTurn.subscribe((balance) -> $('.turn-nr').text(balance))

newPrice.subscribe((balance) -> $('.stock1 .price').text(balance))

balance.subscribe((balance) -> $('.balance').text(balance))

canBuy.subscribe((price) -> $('.stock1 .buy').prop('disabled', false))

cannotBuy.subscribe((price) -> $('.stock1 .buy').prop('disabled', true))

canSell.subscribe((price) -> $('.stock1 .sell').prop('disabled', false))

cannotSell.subscribe((price) -> $('.stock1 .sell').prop('disabled', true))

newBuy.subscribe((price) -> $('.stock1 .sell').prop('disabled', false))

newStockAmount.subscribe((amount) -> $('.stock1 .amount').text(amount))

newPrice.connect()