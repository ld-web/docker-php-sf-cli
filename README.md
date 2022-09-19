# PHP7.4 + Symfony CLI Docker custom image

## Build

```bash
docker build -t ld-web/php:7.4-fpm-sf .
```

## Run

```bash
docker run -d --name php7.4 -v $(pwd)/php:/php ld-web/php:7.4-fpm-sf
```
