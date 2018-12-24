"""robot URL Configuration
"""
from django.conf.urls import url

from django.urls import path
from dice.views import home, contract, ajax_bet

urlpatterns = [
    # XXX /contract to report which contract is in use
    # XXX /ajax/bet to fill DB records (not sure we really want an async-populating thing at the moment)
    url(r'^$', home, name='home'),
    url(r'^contract/$', contract, name='contract'),
    url(r'^ajax/bet/$', ajax_bet, name='ajax_bet'),
]
