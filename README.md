looter
======

Stock trading game

## Development

Open {{index.html}} in the browser.

## Build for node-webkit
    $ grunt buildNW
    $ nw.exe looter.zip

## MS - turn based trading - 01.09.2014
* before first turn buying and selling is disabled
* user can start first turn
* user can start next turn
* game consists of 1 stock with a random price
* in every turn the price is randomly generated
* user can buy stock in a turn
* buying affects balance
* user can only buy for his remaining balance
* when stock is bought user can sell immediately for the current stock price
* selling affects balance
* user can only sell the exact amount of stocks that he bought

## MS - turn limitations - 04.09.2014
* there are no negative prices
* game is limited to ten runs
* user can restart game at any time
* restarting resets balance, turn count and starts new turn

## MS - game over - 06.09.2014
* after 10 runs game a prints the profit
* profit is claculated as percantage

## MS - time limitations - 06.09.2014
* turns are limited in time (3 seconds)
* a progress bar or timer indicates the time left to end the turn with an action
* when the last turn ended automatically, the game ends

## MS - increased diffulty: drugs
* user can start game/turn with drugs
* drugged turn has unreadable stock price
* buying on drugs decreases stock price
* selling on drugs increases stock price
* max possible earnings will be calculated without drugs
* score can get > 100 %

## MS - increased difficulty: multiple stocks
* user can choose between 1 and 2 stocks
* game rules with two stocks are the same as with 1 stock

## MS - strategic element insider information
* insider information will display next value
* user can buy insider information per turn
* costs: 1/3 of his balance and at least 1000 €
* user cannot buy when balance is below 1000 €

## MS - strategic element more time
* user can buy time to extend turn time
* costs: 500 €
* user cannot buy when balance is below 500 €

## MS - build for PhoneGap

## MS - build for node-webkit
* removes browserify <script> from index.html