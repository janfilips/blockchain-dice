"""robot URL Configuration
"""
from django.conf.urls import url

from django.urls import path
from dice.views import home, ajax_bet


urlpatterns = [
    # common views..
    url(r'^$', home, name='home'),
    # ajax
    url(r'^ajax/bet/$', ajax_bet, name='ajax_bet'),
    url(r'^ajax/clock/$', ajax_get_clock, name='ajax_get_clock'),
    url(r'^ajax/tabulky/$', ajax_get_tabulky, name='ajax_get_tabulky'),
    # bytecode, abi
    url(r'^ajax/bytecode/$', get_game_bytecode, name='get_game_bytecode'),
    url(r'^ajax/abi/$', get_game_abi, name='get_game_abi'),
]
