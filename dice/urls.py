import os
from django.conf.urls import url

from django.urls import path
from dice.views import ajax_update_player_wallet
from dice.views import home, ajax_bet, ajax_my_games_html_tabulka, ajax_all_games_html_tabulka
from dice.views import get_game_abi, get_game_contract

urlpatterns = [
    # common views
    url(r'^$', home, name='home'),
    url(r'^abi$', get_game_abi, name='get_game_abi'),
    url(r'^contract$', get_game_contract, name='get_game_contract'),
    # ajax
    url(r'^ajax/bet$', ajax_bet, name='ajax_bet'),
    url(r'^ajax/tabulky/games/all$', ajax_all_games_html_tabulka, name='ajax_all_games_html_tabulka'),
    url(r'^ajax/tabulky/games/mine$', ajax_my_games_html_tabulka, name='ajax_my_games_html_tabulka'),    
    url(r'^ajax/player/update', ajax_update_player_wallet, name='ajax_update_player_wallet'),
]
