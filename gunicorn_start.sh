#!/bin/bash

NAME="ethereum-dice"
DJANGODIR=/var/www/ethereum-dice
SOCKFILE=/var/www/ethereum-dice/gunicorn.sock
USER=hello                                        
GROUP=webapps                                     
NUM_WORKERS=3                                     
DJANGO_SETTINGS_MODULE=dice.settings             
DJANGO_WSGI_MODULE=dice.wsgi                

echo "Starting $NAME as `whoami`"

# Activate the virtual environment
cd $DJANGODIR
#source ../bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Django Unicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec /usr/local/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --bind=unix:$SOCKFILE \
  --log-level=debug \
  --log-file=-
