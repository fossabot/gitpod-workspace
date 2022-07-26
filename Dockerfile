FROM composer:latest as composer

FROM gitpod/workspace-full:latest

USER root

RUN yes | unminimize \
    # 0. Fix permissions
    && chown -R gitpod:gitpod /home/gitpod/.config /home/gitpod/.cache \
    # 1. Registering repos
    && curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash \
    # 2. Upgrading system packages
    && upgrade-packages \
    && composer self-update \
    # 3. Install new apps
    && install-packages \
        symfony-cli \
    # 4. Register ru lang locale
    && locale-gen \
        en_US.UTF-8 \
        ru_RU.UTF-8

RUN update-alternatives --set php $(which php8.1) \
    && pecl channel-update pecl.php.net \
    && pecl install \
        xdebug \
    && echo 'zend_extension=xdebug' > /etc/php/8.1/cli/conf.d/20-xdebug.ini

USER gitpod

RUN brew update --force && brew upgrade && brew cleanup --prune=all
