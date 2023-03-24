# PHP + Symfony CLI Docker custom image

This Docker image aims to be instantiated when wanting to work locally on PHP and/or Symfony.

## Build

```bash
docker build -t ld-web/php-sf-cli .
```

## Run

```bash
# Map a directory to a /php folder created in the container
docker run -d --name php-sf -v $(pwd)/php:/php ld-web/php-sf-cli
```

## Oh My Zsh

Oh My Zsh is installed into the container.

It can be launched from CLI :

```bash
docker exec -it php-sf zsh
```
