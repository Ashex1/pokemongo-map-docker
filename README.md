# Docker Images for pokemongo-map

Further details on PokemonGo-Map can be found here:

https://github.com/PokemonGoMap/PokemonGo-Map.git


## Purpose:

This will pull the latest code from the repository on start. Any restarts of the container will cause it to pull the latest changes. The following images available for use:

* ashex/pokemongo-map:develop - Pulls the develop branch
* ashex/pokemongo-map:latest - Most recent release

For the latest *features* use the develop tag. 


Latest is a built static image while develop are dynamic, pulling in changes from the repository.


## Usage:

### Passing settings


You can either pass settings via arguments that the tool supports or with Environmental variables. If you prefer to use environment variables you need to prepend the variable with `POKEMON_`. For example: 

```bash
docker run -d -P \
   --name pokemongo-map \
   -e "POKEMON_AUTH_SERVICE=ptc" \
   -e "POKEMON_USERNAME=UserName" \
   -e "POKEMON_PASSWORD=Password" \
   -e "POKEMON_LOCATION=Seattle, WA" \
   -e "POKEMON_STEP_LIMIT=5" \
   -e "POKEMON_GMAPS_KEY=SUPERSECRET" \
   ashex/pokemongo-map:develop
```

or

```bash
  docker run -d -P \
    --name pokemongo-map \
    ashex/pokemongo-map:develop \
    --auth-service ptc \
    --username UserName \
    --password Password \
    --location "Seattle, WA" \
    --step-limit "5" \
    --gmaps-key "SUPERSECRET"
```

If you are spinning up a group of containers with a database container you likely need to make them wait for the database to be ready. You can do so by specifying a variable `POKEMON_DB_WAIT`, the existence of this variable will cause the container to wait 10 seconds before running the tool.


### Multi-User threading

The develop branch recently added support for multiple users by assigning each thread a user to search with. You can use it by passing them as arguments but the process is more elegant when using variables since they are used to create config.ini. The variables would simply contain a list that the configargparse library understands and would process natively. Below is an example of how the variables would be structured:

```bash
docker run -d -P \
   --name pokemongo-map \
   -e "POKEMON_AUTH_SERVICE=ptc" \
   -e "POKEMON_USERNAME=[user1, user2]" \
   -e "POKEMON_PASSWORD=[password1, password]" \
   -e "POKEMON_LOCATION=Seattle, WA" \
   -e "POKEMON_STEP_LIMIT=5" \
   -e "POKEMON_GMAPS_KEY=SUPERSECRET" \
   ashex/pokemongo-map:develop
```
