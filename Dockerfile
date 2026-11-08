ARG BASE_REF=php:8.5.12-fpm

FROM ${BASE_REF}

ARG IMAGICK_VERSION=3.8.1

SHELL ["/bin/bash", "-eux", "-o", "pipefail", "-c"]

RUN savedAptMark="$(apt-mark showmanual)" \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libbz2-dev \
        libfreetype-dev \
        libgmp-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libldap-dev \
        libmagickwand-dev \
        libonig-dev \
        libpng-dev \
        libtidy-dev \
        libxml2-dev \
        libxslt1-dev \
        libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j"$(nproc)" \
        bcmath \
        bz2 \
        calendar \
        exif \
        gd \
        gettext \
        gmp \
        intl \
        ldap \
        mysqli \
        pcntl \
        pdo_mysql \
        soap \
        sockets \
        tidy \
        xsl \
        zip \
    && pecl install imagick-${IMAGICK_VERSION} \
    && docker-php-ext-enable imagick \
    # Preserve the base image's packages and the extensions' shared libraries.
    && apt-mark auto '.*' > /dev/null \
    && apt-mark manual $savedAptMark > /dev/null \
    && find "$(php-config --extension-dir)" -type f -name '*.so' -exec ldd '{}' + \
        | awk '/=> \// { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); printf "*%s\n", so }' \
        | sort -u \
        | xargs -r dpkg-query --search \
        | awk 'sub(":$", "", $1) { print $1 }' \
        | sort -u \
        | xargs -r apt-mark manual \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && docker-php-source delete \
    && rm -rf /tmp/pear /var/lib/apt/lists/* /var/cache/apt/archives/*
