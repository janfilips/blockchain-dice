import os
from django.conf.urls import url

from django.urls import path
from dice.views import ajax_update_player_wallet, ajax_notifications
from dice.views import home, ajax_bet, ajax_games_html_table
from dice.views import get_game_abi, get_game_contract

urlpatterns = [
    # common views
    url(r'^$', home, name='home'),
    url(r'^abi/$', get_game_abi, name='get_game_abi'),
    url(r'^contract/$', get_game_contract, name='get_game_contract'),
    # ajax
    url(r'^ajax/bet/$', ajax_bet, name='ajax_bet'),
    url(r'^ajax/notifications/$', ajax_notifications, name='ajax_notifications'),
    url(r'^ajax/games/$', ajax_games_html_table, name='ajax_games_html_table'),
    url(r'^ajax/player/update/', ajax_update_player_wallet, name='ajax_update_player_wallet'),
]
