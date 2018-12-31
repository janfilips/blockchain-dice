
import os
import random
import datetime
import json

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

@register.filter(name="get_list_len_from_string")
def get_list_len_from_string(input_string):
    return len(json.loads(input_string))

@register.filter(name="get_list_from_string")
def get_list_from_string(input_string):
    return json.loads(input_string)

@register.filter(name="get_list_len")
def get_list_len(input_string):
    input_list = json.loads(input_string)
    return len(input_list)
