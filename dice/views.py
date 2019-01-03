# -*- coding: utf-8 -*-
import os
import sys
import web3
import django
import datetime
import random
import uuid
import time

from web3.auto import w3

from datetime import timedelta
from django.utils import timezone

from django.conf import settings
from django.core import serializers
from django.http import JsonResponse, HttpResponseRedirect, HttpResponse
from django.shortcuts import render, redirect, get_object_or_404

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "dice.settings")
django.setup()

from dice.models import Bets
from dice.models import Players
from dice.models import Events

from web3 import Web3, Account
from web3.providers.rpc import HTTPProvider

import logging
logger = logging.getLogger(__name__)


def home(request):

    player_wallet = None

    try:
        session_key = request.COOKIES["session_key"]
    except:
        session_key = uuid.uuid4()

    try:
        player = Players.objects.get(session_key=session_key)
        player_session_key = player.session_key
        player_wallet = player.address
    except Players.DoesNotExist:
        player_session_key = session_key


    # XXX TODO filter for paired transactions only (status=1, tx_hash and player is not empty)
    # XXX TODO manualne zredukuj games list povuhadzuj z neho len par tych co prehrali.....
    games = Bets.objects.filter().order_by('-pk')[:100]

    my_games_time_threshold = datetime.datetime.now() - timedelta(hours=24)
    my_games = Bets.objects.filter(player=player_wallet,created__gt=my_games_time_threshold).order_by('-pk')

    response = render(
        request=request,
        template_name='index.html',
        context={
            'contract': settings.ETHEREUM_DICE_CONTRACT,
            'contract_abi': settings.ETHEREUM_DICE_CONTRACT_ABI,
            'games': games,
            'my_games': my_games,
            'player_session_key': player_session_key,
            'player_wallet': player_wallet,
            },
    )
    response.set_cookie(key="session_key",value=session_key)

    return response


def get_game_abi(request):

    return HttpResponse(settings.ETHEREUM_DICE_CONTRACT_ABI)


def get_game_contract(request):

    if('ropsten' in settings.ETHEREUM_PROVIDER_HOST):
        etherscan_url = "https://ropsten.etherscan.io/address/"+settings.ETHEREUM_DICE_CONTRACT
    else:
        etherscan_url = "https://etherscan.io/address/"+settings.ETHEREUM_DICE_CONTRACT

    return HttpResponseRedirect(etherscan_url)


def ajax_bet(request):
    
    player_wallet = request.POST.get('wallet')
    bet_tx_hash = request.POST.get('value')
    bet_amount = request.POST.get('amount')

    bet_numbers = request.POST.getlist('numbers[]')

    _bet_numbers = []
    for _number in  bet_numbers:
        _bet_numbers.append(int(_number))
    bet_numbers = _bet_numbers

    Bets.objects.create(
        player = player_wallet,
        tx_hash = bet_tx_hash,
        amount = bet_amount,
        numbers = str(bet_numbers),
    )

    return HttpResponse('Ok')


def ajax_update_player_wallet(request):

    player_wallet = request.POST.get('wallet')
    player_session_key = request.POST.get('player_session_key')

    player = Players.objects.get_or_create(session_key=player_session_key)
    player = player[0]
    player.address = player_wallet
    player.save()

    return HttpResponse('Ok')


def ajax_notifications(request):

    player = request.POST.get('wallet')
    events = Events.objects.filer(player=player, seen_by_player=True)

    player_notifications = []

    # marking off notifs as seen by user
    for notification in events:
        notification.seen_by_player = True
        notification.save()
        notification.append(notification)
 
    return JsonResponse(player_notifications, safe=False)


def ajax_my_games_html_tabulka(request):

    player_wallet = request.POST.get('wallet')
    time_threshold = datetime.datetime.now() - timedelta(day=1)
    my_games = Bets.objects.filter(player=player_wallet,created__gt=time_threshold).order_by('-pk')[:100]
    # XXX todo
    return JsonResponse([], safe=False)

def ajax_all_games_html_tabulka(request):
    # XXX TODO ajax call to list games table
    # XXX TODO filter for paired transactions only (status=1, tx_hash and player is not empty)
    # XXX TODO manualne zredukuj games list povuhadzuj z neho len par tych co prehrali.....
    return JsonResponse([], safe=False)


