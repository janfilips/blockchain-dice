import os

from django.conf import settings
from django.db import models

from django.contrib.auth import get_user_model


class Topups(models.Model):
    address = models.CharField(max_length=42)
    amount = models.FloatField()
    tx_hash = models.CharField(max_length=42)
    created = models.DateTimeField(auto_now=True)

class Bets(models.Model):
    status = models.BooleanField(default=0)
    player = models.CharField(max_length=42)
    win_number = models.IntegerField(default=0)
    numbers = models.CharField(max_length=42, default="")
    amount = models.FloatField(default=0)
    win_amount = models.FloatField(default=0)
    tx_hash = models.CharField(max_length=42)
    oracle_query_id = models.CharField(max_length=42, default="")
    contract = models.CharField(max_length=42)
    blocknumber = models.IntegerField(default=0)
    created = models.DateTimeField(auto_now=True)

class Wallets(models.Model):
    address = models.CharField(max_length=42)
    balance = models.FloatField(default=0)
    bets_count = models.IntegerField(default=0)
    created = models.DateTimeField(auto_now=True)

class Decommissioned_Wallets(models.Model):
    address = models.CharField(max_length=42)
    balance = models.FloatField(default=0)
    keystore = models.CharField(max_length=2048) 
    bets_count = models.IntegerField(default=0)
    created = models.DateTimeField(auto_now=True)
