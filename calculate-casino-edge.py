import os
import time
import random

vklad = 0.05
casino_balance = 0
player_balance = 0

WIN_MULTIPLAYER = 10

counter = 0
win_games = 0


while True:

    number = random.randint(1,20)
    if(number==20):
        win_games += 1
        player_balance += WIN_MULTIPLAYER * vklad
        casino_balance -= WIN_MULTIPLAYER * vklad
    else:
        casino_balance += vklad


    print(WIN_MULTIPLAYER)
    print(counter, win_games)  
    print('casino_balance', casino_balance)
    print('player_balance', player_balance)
    os.system('clear')

    counter += 1
