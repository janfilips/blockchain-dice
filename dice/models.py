import os

from django.conf import settings
from django.db import models


class Players(models.Model):
    address = models.CharField(max_length=128, default="")
    session_key = models.CharField(max_length=128)

class Bets(models.Model):
    status = models.BooleanField(default=0)
    player = models.CharField(max_length=128)
    win_bet = models.BooleanField(default=0)
    win_number = models.IntegerField(default=0)
    numbers = models.CharField(max_length=128, default="")
    amount = models.FloatField(default=0)
    win_amount = models.FloatField(default=0)
    tx_hash = models.CharField(max_length=128)
    callback_tx_hash = models.CharField(max_length=128)
    oracle_query_id = models.CharField(max_length=128, default="")
    contract = models.CharField(max_length=128)
    created = models.DateTimeField(auto_now=True)

class Events(models.Model):
    event_type = models.CharField(max_length=32)
    oracle_query_id = models.CharField(max_length=128)
    tx_hash = models.CharField(max_length=128)
    player = models.CharField(max_length=128)
    numbers = models.CharField(max_length=128, default="")
    win_number = models.IntegerField(default=0)
    amount = models.FloatField(default=0)
    win_amount = models.FloatField(default=0)
    created = models.DateTimeField(auto_now=True)
    seen_by_player = models.BooleanField(default=0)
    seen_on = models.DateTimeField(null=True)
