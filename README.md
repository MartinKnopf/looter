looter
======

Stock trading game

## Development
Start a watch job that builds using browserify:

    $ grunt browserifyWithWatch

Then open {{index.html}} in the browser.

## Build for node-webkit
    $ grunt buildNW
    $ nw.exe looter.zip

## MS - turn based trading
* user can start first turn
* game consists of 1 stock with a random price
* in every turn the price is randomly generated
* when stock is not bought user can buy stock in a turn
* buying affects balance
* buying leads to next turn
* when stock is bought user can sell in next turn
* selling affects balance
* selling leads to next turn

## MS - turn limitations
* game is limited to ten runs
* user can restart game at any time
* restarting resets balance, turn count and starts new turn

## MS - score
* after 10 runs game prints maximum possible earning
* a score is shown, claculated as percantage of max possible earning

## MS - time limitations
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
* user can choose to start game with two stocks
* max possible earnings will be calculated for two stocks
* number of stocks affects score: score = score * (1 + 0.1 * number of stocks)

## MS - build for PhoneGap

## MS - build for node-webkit
* removes browserify <script> from index.html