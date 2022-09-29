# PHP7.4 + Symfony CLI Docker custom image

## Build

```bash
docker build -t ld-web/php:7.4-fpm-sf .
```

## Run

```bash
docker run -d --name php7.4 -v $(pwd)/php:/php ld-web/php:7.4-fpm-sf
```

## Oh My Zsh

Oh My Zsh is installed into the container.

It can be launched from CLI :

```bash
docker exec -it php7.4 zsh
```

If container was attached to VSCode, then from a terminal using default bash, run `zsh`

> **TODO :** See how to make VSCode launch `zsh` directly
