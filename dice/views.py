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



def ajax_get_tabulky(request):

    bets = Bets.objects.all().order_by('-pk')[:100]

    return JsonResponse(bets, safe=False)


def ajax_bet(request):
    return HttpResponse('xxx todo working on this currently')



def home(request):

    response = render(
        request=request,
        template_name='index.html',
        context={
            'contract': settings.ETHEREUM_DICE_CONTRACT,
            'contract_abi': settings.ETHEREUM_DICE_CONTRACT_ABI,
            },
    )

    return response
