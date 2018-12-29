
import os
import random
import datetime
from django import template
from django.conf import settings
from django.utils import timezone

from web3.auto import w3

register = template.Library()

@register.filter(name='dict_get')
def dict_get(h, key):
    try:
        return h[key]
    except:
        return None


@register.filter(name="random_int")
def random_int(a, b=None):
    if b is None:
        a, b = 0, a
    return random.randint(a, b)

@register.filter(name="to_wei")
def to_wei(value):
    return w3.toWei(value,'ether')
