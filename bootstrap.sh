#!/bin/bash

# Download the latest Bitcoin Gold Core release
mkdir base &> /dev/null
(cd base && curl -O -L https://github.com/BTCGPU/BTCGPU/releases/download/v0.17.3/bitcoin-gold-0.17.3-x86_64-linux-gnu.tar.gz)
# Unzip to ./bitcoin-gold
mkdir base/bitcoin-gold &> /dev/null
(cd base && tar --strip-components=1 -xf bitcoin-gold-0.17.3-x86_64-linux-gnu.tar.gz -C ./bitcoin-gold/)
# Clone bitcore git repo
(cd base && git clone https://github.com/BTCGPU/bitcore.git)

echo '''
Next step: Build Bitcore & Insight:

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
