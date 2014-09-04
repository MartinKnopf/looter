stocks = [{
  min: 900,
  max: 3500
}]

sinPrice = (min, max, x) -> Math.floor((Math.sin(x) + 1.4) * (max + 1 - min) + min)
randomize = (min, max, price) -> Math.floor(_.random(price - _.random(min, max) / 2, price + _.random(min, max) / 2))
maxDiff (int arr[], int n)
{
    // Initialize diff, current sum and max sum
    int diff = arr[1]-arr[0];
    int curr_sum = diff;
    int max_sum = curr_sum;
 
    for(int i=1; i<n-1; i++)
    {
        // Calculate current diff
        diff = arr[i+1]-arr[i];
 
        // Calculate current sum
        if (curr_sum > 0)
           curr_sum += diff;
        else
           curr_sum = diff;
 
        // Update max sum, if needed
        if (curr_sum > max_sum)
           max_sum = curr_sum;
    }
 
    return max_sum;
}
resetUi = ->
  $('.turn-nr').text('')
  $('.stock1 .price').text('')
  $('.max-possible-balance-container').hide()
  $('.score-container').hide()

resetUi()

clickStartGame  = Rx.Observable.fromEvent($('.start-new-game'), 'click')

clickStartGame.subscribe(->

  resetUi()

  $('.end-turn').prop('disabled', false)

  clickNextTurn = Rx.Observable.fromEvent($('.end-turn'), 'click')
  clickBuy      = Rx.Observable.fromEvent($('.stock1 .buy'), 'click')
  clickSell     = Rx.Observable.fromEvent($('.stock1 .sell'), 'click')

  newTurn = clickNextTurn
    .startWith(1)
    .select((event, idx) -> idx + 1)
    .take(11)

  lastTurn = newTurn
    .filter((x) -> x > 10)

  newPrice = newTurn
    .map(_.partial(sinPrice, stocks[0].min, stocks[0].max))
    .map(_.partial(randomize, stocks[0].min, stocks[0].max))
    .takeUntil(lastTurn)
    .publish()

  lowestPrice = newPrice
    .scan(10000, (acc, price) -> if acc <= price then acc else price)

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

  maxPossibleBalance = lastTurn
    .merge(
      balance
        .last()
        .combineLatest(newPrice.toArray(), (balance, prices) ->
          minPrice = _.min(prices)
          maxprice = _.max(prices)
          if _.find(minPrice) > _.find(maxPrice)
            # ...
          
          Math.floor(10000 / minPrice) * maxPrice))

  score = maxPossibleBalance
    .combineLatest(balance.last(), (max, actual) -> Math.round(actual / max * 10000) / 100)

  newTurn.subscribe((turn) -> $('.turn-nr').text(turn))

  lastTurn.subscribe(->
    $('.turn-nr').text('game over')
    $('.end-turn').prop('disabled', true))

  newPrice.subscribe((price) -> $('.stock1 .price').text(price))

  balance.subscribe((balance) -> $('.balance').text(balance))

  canBuy.subscribe(-> $('.stock1 .buy').prop('disabled', false))

  cannotBuy.subscribe(-> $('.stock1 .buy').prop('disabled', true))

  canSell.subscribe(-> $('.stock1 .sell').prop('disabled', false))

  cannotSell.subscribe(-> $('.stock1 .sell').prop('disabled', true))

  newBuy.subscribe(-> $('.stock1 .sell').prop('disabled', false))

  newStockAmount.subscribe((amount) -> $('.stock1 .amount').text(amount))

  maxPossibleBalance.subscribe((maxPossibleBalance) ->
    $('.max-possible-balance-container').show()
    $('.max-possible-balance').text(maxPossibleBalance))

  score.subscribe((score) ->
    $('.score-container').show()
    $('.score').text(score + ' %'))

  # connected observables  
  newPrice.connect()
)