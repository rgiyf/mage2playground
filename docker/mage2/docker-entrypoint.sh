#!/bin/bash

[[ "${DEBUG}" = "true" ]] && set -x

# Update Configuration Files
[[ ! -z "${PHP_MEMORY_LIMIT}" ]] && sed -i "s/!PHP_MEMORY_LIMIT!/${PHP_MEMORY_LIMIT}/" /usr/local/etc/php/conf.d/zz-mage2.ini
[[ ! -z "${UPLOAD_MAX_FILESIZE}" ]] && sed -i "s/!UPLOAD_MAX_FILESIZE!/${UPLOAD_MAX_FILESIZE}/" /usr/local/etc/php/conf.d/zz-mage2.ini
[[ ! -z "${MAGENTO_RUN_MODE}" ]] && sed -i "s/!MAGENTO_RUN_MODE!/${MAGENTO_RUN_MODE}/" /usr/local/etc/php-fpm.conf

# Ensure our Magento directory exists
mkdir -p ${MAGENTO_ROOT}

[[ "${PHP_ENABLE_XDEBUG}" = "true" ]] && \
    docker-php-ext-enable xdebug && \
    echo "Xdebug is enabled"

exec "$@"