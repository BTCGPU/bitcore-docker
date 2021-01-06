# Bitcore Insight Docker for BTG

## First Run

1. [Intall Docker and docker-compose](#appendix-server-prepration-sample)
2. Clone this repo

    ```bash
    git clone https://github.com/BTCGPU/bitcore-docker.git
    ```

3. Run `bootstrap.sh` to download all the necessary dependencies for the docker containers

    ```bash
    ./bootstrap.sh
    ```

4. Follow the instructions output by `bootstrap.sh` to compile bitcore. You have to spawn a shell in `bitcore` container, initialize the bitcore project and compile it.

    > Next step: Build Bitcore & Insight:
    >
    > First, enter a shell in the Bitcore container (defined in the docker-compose file):
    >   ```bash
    >   docker-compose run --rm --no-deps --entrypoint /bin/bash bitcore
    >   ```
    >
    > Then within the shell, run the following to compile everything (Bitcore and Insight):
    >   ```bash
    >   cd /opt/bitcore
    >   npm install
    >   npm run bootstrap
    >   npm run compile
    >   (cd packages/insight && npm run build:prod)
    >   ```
    >
    > Once finished, you will have the compiled static frontend build at:
    >
    >   ```
    >   /opt/bitcore/packages/insight/www/
    >   ```
5. Config `docker-compose.yml` for a specific network. 
5. Start the full stack (`-d` for daemon mode)

    ```bash
    docker-compose up -d
    ```

## Prod Deployment

The docker-compose file is shipped with Caddy web server which manages TLS automatically when deployed in a public server with the correct port mapping. By default it points to `explorer.test.bitcoingold.dev`. Change it to deploy on other domains. You can find the config under `config/`.

The multi-network config can be enabled by modifiying `docker-compose.yml` file. By default the docker-compose file only enables testnet. To enable both the mainnet and the testnet, uncomment the mainnet full node service and change the bitcore config file from `bitcore.json` to `bitcore-multi.json` (follow the comments).

## Maintenance

- Stop the full stack:

    ```sh
    docker-compose down
    ```

- Start the full stack (daemon mode):

    ```sh
    docker-compose up -d
    ```

- Adjust the configs

    1. Stop the containers
    2. Make changes in the config files
    3. Start the containers

- Upgrade

    1. Stop the containers
    2. Run `./update-bitcore.sh`
    3. Follow the instructions output by `update-bitcore.sh` to recompile bitcore like what we did in
    "First run" section.
    4. Start the containers again

- Database and storage: They are defined and well documented in `volumes` configration in `docker-compose.yml`.

- Dynamic DNS: `ddns/` has a docker-compose for automatic Cloudflare ddns configuration.

## Performance Tweak

Bitcoin Gold Core config file can be tweaked as usual (dbcache, etc)

The Bitcore config file has a field "maxPoolSize" specifying the database connection threads. It's suggested to set it to the CPU core number. A very high number doesn't help syncing speed a lot.

A rough syncing time breakdown:

- 5% downloading blocks
- 50% block ETL and validation
- 30% write to the database
- 15% waiting for sequential operations

## Appendix: Server Prepration Sample

Create the directories:

```bash
sudo mkdir /opt/btg && sudo chmod 777 /opt/btg
```

Install Docker & docker-composer:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```
