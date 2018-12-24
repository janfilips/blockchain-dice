# -*- coding: utf-8 -*-
import datetime
import random

import json

from datetime import timedelta
from django.utils import timezone

from django.conf import settings
from django.core import serializers
from django.http import JsonResponse, HttpResponseRedirect, HttpResponse
from django.shortcuts import render, redirect, get_object_or_404

#from dice.models import Bets

from web3 import Web3, Account
from web3.providers.rpc import HTTPProvider

w3 = Web3(HTTPProvider(settings.ETHEREUM_PROVIDER))

import logging
logger = logging.getLogger(__name__)

from robot_topup_wallets import update_wallet_balances



def home(request):
    return HttpResponse(settings.ETHEREUM_DICE_CONTRACT)

def contract(request):
    return HttpResponse(settings.ETHEREUM_DICE_CONTRACT)

def ajaxBet(request):
    return HttpResponse(settings.ETHEREUM_DICE_CONTRACT)

