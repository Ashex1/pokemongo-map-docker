#!/bin/sh

# Grab the variables starting with POKEMON_
# and create the config.ini with them
create_config_ini ()
{

    IFS=$'\n'
    set -f
    for VAR in `env`
    do
      case "$VAR" in
          POKEMON_* )
          key_name=`echo "$VAR" | sed -e "s/^POKEMON_\([^=]*\)=.*/\L\1/" -e 's/_/-/g'`
          echo "Setting value of" $key_name
          key_value=`echo "$VAR" | sed -e "s/[^=]*=\(.*\)/\1/"`
          echo "$key_name: $key_value" >> config/config.ini
          ;;
        esac
    done
}

# Generate config.ini on first run only
if [ ! -f "config/config.ini" ]; then
    create_config_ini
else
   # Clean up mystery core dumps
   rm /app/core.*
fi

if [[ -n "$POKEMON_DB_WAIT" ]]; then
   echo "Just in case we're spinning up a database container we will sleep for 10 seconds to let it initialise"
   sleep 10
fi
python runserver.py --host 0.0.0.0 "$@"


