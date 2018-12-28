# -*- coding: utf-8 -*-
import os
import sys
import web3
import django
import datetime
import random
import time

from datetime import timedelta
from django.utils import timezone

from django.conf import settings
from django.core import serializers
from django.http import JsonResponse, HttpResponseRedirect, HttpResponse
from django.shortcuts import render, redirect, get_object_or_404

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "dice.settings")
django.setup()

from web3 import Web3, Account
from web3.providers.rpc import HTTPProvider

w3 = Web3(HTTPProvider(settings.ETHEREUM_PROVIDER))

import logging
logger = logging.getLogger(__name__)

from dice.models import Bets



def get_game_abi(request):

    return HttpResponse(settings.ETHEREUM_DICE_CONTRACT_ABI)

def get_game_contract(request):

    return HttpResponse(settings.ETHEREUM_DICE_CONTRACT)


def get_clock(request):

    print('ajax_get_clock')

    now = datetime.datetime.now(tz=timezone.utc).isoformat()

    return JsonResponse({'clock': now})


def ajax_bet(request):
    
    bet_numbers = request.POST['numbers']
    bet_amount = request.POST['value']
    bet_tx_hash = request.POST['tx_hash']
    player_wallet = request.POST['player_wallet']

    # xxx todo create a new wallet
    # xxx update 

    print('bet_tx_hash',bet_tx_hash,'bet_numbers',bet_numbers,'tx_hash', bet_tx_hash)

    return HttpResponse('Ok')


def ajax_my_games(request):
    # XXX todo filter my games
    return HttpResponse('xxx todo filter my games')

def ajax_games_history(request):
    bets = Bets.objects.all().order_by('-pk')[:100]
    return JsonResponse(bets, safe=False)


def home(request):

    games = Bets.objects.all().order_by('-pk')

    response = render(
        request=request,
        template_name='index.html',
        context={
            'contract': settings.ETHEREUM_DICE_CONTRACT,
            'contract_abi': settings.ETHEREUM_DICE_CONTRACT_ABI,
            'games': games,
            },
    )

    return response


def temp_devel_shit_deleteme(request):

    games = Bets.objects.all().order_by('-pk')

    response = render(
        request=request,
        template_name='test.html',
        context={
            'contract': settings.ETHEREUM_DICE_CONTRACT,
            'contract_abi': settings.ETHEREUM_DICE_CONTRACT_ABI,
            'games': games,
            },
    )

    return response
