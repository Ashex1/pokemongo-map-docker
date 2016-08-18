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
if [ ! -d "config" ]; then
    mkdir config
    create_config_ini
fi

# If the repo has already been created, pull the latest changes
# Otherwise create and clone the repo
if [ -d ".git" ]; then
    #Clean up mystery core dumps
    rm /app/core.*
    git reset --hard origin/develop
    git pull origin develop
    pip install -r requirements.txt
    npm update
    npm run-script build
    python runserver.py --host 0.0.0.0 "$@"

else
    git init
    git remote add origin https://github.com/PokemonGoMap/PokemonGo-Map.git
    git pull origin develop
    pip install -r requirements.txt
    npm install
    npm run-script build
    python runserver.py --host 0.0.0.0 "$@"
fi


