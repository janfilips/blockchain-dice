import os

from django.conf import settings
from django.db import models

from django.contrib.auth import get_user_model


class Bets(models.Model):
    address = models.CharField(max_length=42)
    amount = models.FloatField()
    betNumbers = models.CharField(max_length=42)
    winNumber = models.IntegerField(default=0)
    winAmount = models.FloatField(default=0)
    tx_hash = models.CharField(max_length=42)
    tx_receipt = models.CharField(max_length=2048, default="")
    status = models.BooleanField(default=0)
    is_robot = models.BooleanField(default=0)
    created = models.DateTimeField(auto_now=True)

