# -*- coding: utf-8 -*-
import os
import web3
import django
import datetime
import uuid

from web3.auto import w3

from datetime import timedelta

from django.conf import settings
from django.http import JsonResponse, HttpResponseRedirect, HttpResponse
from django.shortcuts import render, redirect

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

    response = render(
        request=request,
        template_name='index.html',
        context={
            'contract': settings.ETHEREUM_DICE_CONTRACT,
            'contract_abi': settings.ETHEREUM_DICE_CONTRACT_ABI,
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
        etherscan_url = "https://etherscan.io/address/"+settings.ETHEREUM_DICE_CONTRACT
    else:
        etherscan_url = "https://etherscan.io/address/"+settings.ETHEREUM_DICE_CONTRACT

    return HttpResponseRedirect(etherscan_url)


def ajax_notifications(request):

    player = request.POST.get('wallet')
    recent_event = Events.objects.filter(player=player, seen_by_player=False).last()

    notification_text = ""

    if(recent_event):

        tx_hash_shorten = recent_event.tx_hash[:30]+'...'+recent_event.tx_hash[-10:]

        if(recent_event.event_type == "player_wins"):
            notification_text = "<div class=\"notifText winNotif\">Congratulations your transaction <a href=\"https://etherscan.io/tx/"+recent_event.tx_hash+"\" target=\"_blank\"><font color=\"#C0C0C0\">"+str(tx_hash_shorten)+"</font></a> "+str(recent_event.amount)+" bet "+str(recent_event.numbers).replace('[','').replace(']','')+" on number <b>"+str(recent_event.win_number)+"</b> wins <b>"+str(recent_event.win_amount)+" Ether</b>.</div>"

        if(recent_event.event_type == "player_loses"):
            notification_text = "<div class=\"notifText lostNotif\">Transaction <a href=\"https://etherscan.io/tx/"+recent_event.tx_hash+"\" target=\"_blank\"><font color=\"#C0C0C0\">"+tx_hash_shorten+"</font></a> betting on numbers "+ str(recent_event.numbers).replace('[','').replace(']','') +" did not win, the winning number was <b>"+ str(recent_event.win_number) +"</b>.</div>"

        recent_event.seen_by_player = True
        recent_event.seen_on = datetime.datetime.now()
        recent_event.save()

    return HttpResponse(notification_text)


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


def ajax_games_html_table(request):

    my_games = False

    if(request.POST):
        my_games = True
        player_wallet = request.POST.get('wallet')
        my_games_time_threshold = datetime.datetime.now() - timedelta(hours=12)
        games = Bets.objects.filter(player=player_wallet,created__gt=my_games_time_threshold).order_by('-pk')[:50]
    else:
        games = Bets.objects.filter(status=1).order_by('-pk')[:50]

    if(games):
        response = render(
            request=request,
            template_name='games-table.html',
            context={
                'games': games,
                'my_games': my_games,
                },
        )
        return response
    
    return HttpResponse("")


def ajax_update_player_wallet(request):

    player_wallet = request.POST.get('wallet')
    player_session_key = request.POST.get('player_session_key')

    player = Players.objects.get_or_create(session_key=player_session_key)
    player = player[0]
    player.address = player_wallet
    player.save()

    return HttpResponse('Ok')

