# PHP-FPM

PHP 8.5.12 FPM, based on the official `php:8.5.12-fpm` image, with additional PHP extensions.

## Published tags

Both registries receive the same image:

```text
ghcr.io/treyturner/php:8.5.12-fpm
forgejo.treyturner.info/treyturner/php:8.5.12-fpm
```

## Inventory

In addition to the base image's extensions:

- `bcmath`, `bz2`, `calendar`, `exif`, `gettext`, `gmp`, `intl`, `ldap`
- `gd` with FreeType and JPEG support
- `mysqli`, `pdo_mysql`
- `pcntl`, `soap`, `sockets`, `tidy`, `xsl`, `zip`
- `imagick` 3.8.1

Development libraries added to build these extensions are removed after compilation;
their required runtime libraries are retained. Build tools inherited from the PHP
base image remain available.

## Builds

Pushes to `main` build and test the image before publishing to both registries.
Pull requests and manual runs build and test without publishing. Manual runs can
override `base-ref` and `imagick-version`.
