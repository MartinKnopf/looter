stocks = [{
  min: 900,
  max: 3500
}]

sinPrice = (min, max, x) -> Math.floor((Math.sin(x) + 1.4) * (max + 1 - min) + min)
randomize = (min, max, price) -> Math.floor(_.random(price - _.random(min, max) / 2, price + _.random(min, max) / 2))

initApp = Rx.Observable.return(true)
clickStartGame = Rx.Observable.fromEvent($('.start-new-game'), 'click')

clickStartGame.subscribe(->

  $('.end-turn').prop('disabled', false)

  clickNextTurn = Rx.Observable.fromEvent($('.end-turn'), 'click')
  clickBuy      = Rx.Observable.fromEvent($('.stock1 .buy'), 'click')
  clickSell     = Rx.Observable.fromEvent($('.stock1 .sell'), 'click')

  resettableTimer = clickNextTurn
    .merge(Rx.Observable.interval(3000).takeUntil(clickNextTurn)
      .merge(clickNextTurn
        .flatMap(-> Rx.Observable.interval(3000).takeUntil(clickNextTurn))))
    .takeUntil(clickStartGame)

  newTurn = resettableTimer
    .startWith(1)
    .select((event, idx) -> idx + 1)
    .take(11)

  lastTurn = newTurn
    .filter((turn) -> turn > 10)
    .combineLatest(clickNextTurn, (turn, event) -> turn)
    .takeUntil(clickStartGame)

  newPrice = newTurn
    .map(_.partial(sinPrice, stocks[0].min, stocks[0].max))
    .map(_.partial(randomize, stocks[0].min, stocks[0].max))
    .takeUntil(lastTurn)
    .publish()

  newBuy = Rx.Observable
    .combineLatest(clickBuy, newPrice, (event, price) -> {event: event, price: price})
    .distinctUntilChanged((x) -> x.event)
    .map((x) -> -x.price)
    .takeUntil(lastTurn)

  newSell = Rx.Observable
    .combineLatest(clickSell, newPrice, (event, price) -> {event: event, price: price})
    .distinctUntilChanged((x) -> x.event)
    .map((x) -> x.price)
    .takeUntil(lastTurn)

  newStockAmount = newBuy
    .map(() -> 1)
    .merge(newSell.map(() -> -1 ))
    .scan(0, (acc, x) -> acc + x)
    .startWith(0)
    .takeUntil(lastTurn)

  balance = Rx.Observable
    .merge(newBuy, newSell)
    .startWith(10000)
    .scan((sum, price) -> sum + price)
    .takeUntil(lastTurn)

  canBuy = Rx.Observable
    .combineLatest(balance, newPrice, (balance, price) -> {balance: balance, price: price})
    .filter((x) -> x.balance >= x.price)
    .takeUntil(lastTurn)

  cannotBuy = Rx.Observable
    .combineLatest(balance, newPrice, (balance, price) -> {balance: balance, price: price})
    .filter((x) -> x.balance < x.price)
    .merge(lastTurn)
    .startWith(true)

  canSell = newStockAmount
    .filter((amount) -> amount > 0)
    .takeUntil(lastTurn)

  cannotSell = newStockAmount
    .filter((amount) -> amount <= 0)
    .merge(lastTurn)
    .startWith(true)

  progressBar = newTurn
    .flatMap(-> Rx.Observable.timer(0, 1000).take(3))
    .map((x) -> 3-x)
    .startWith(3)
    .takeUntil(lastTurn)

  profit = balance
    .last()
    .map((x) -> Math.round((x - 10000) / 10000 * 100 * 100) / 100)
    .map((x) -> x + ' %')

  gameOver = lastTurn.map(-> 'game over')

  szep.ctrl('game',
    initApp: initApp
    clickStartGame: clickStartGame
    newPrice: newPrice
    newStockAmount: newStockAmount
    canBuy: canBuy
    newBuy: newBuy
    cannotBuy: cannotBuy
    canSell: canSell
    cannotSell: cannotSell
    newTurn: newTurn
    balance: balance
    progressBar: progressBar
    lastTurn: lastTurn
    gameOver: gameOver
    profit: profit)

  # connected observables  
  newPrice.connect()
)