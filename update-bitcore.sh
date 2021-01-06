#!/bin/bash

(cd base/bitcore && git pull)

echo '''
Next step: Rebuild Bitcore & Insight:

First, enter a shell in the Bitcore container (defined in the docker-compose file):
  docker-compose run --rm --no-deps --entrypoint /bin/bash bitcore

Then within the shell, run the following to compile everything (Bitcore and Insight):
  cd /opt/bitcore
  npm install
  npm run bootstrap
  npm run compile
  (cd packages/insight && npm run build:prod)

Once finished, you will have the compiled static frontend build at:
  /opt/bitcore/packages/insight/www/
'''
