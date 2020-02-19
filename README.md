Base Apache Docker Container for RIDI Select
========================================================

[![Build Status](https://travis-ci.org/ridibooks-docker/ridiselect-apache-base.svg?branch=master)](https://travis-ci.org/ridibooks-docker/ridiselect-apache-base)
[![](https://images.microbadger.com/badges/version/ridibooks/ridiselect-apache-base.svg)](http://microbadger.com/images/ridibooks/ridiselect-apache-base "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/ridibooks/ridiselect-apache-base.svg)](http://microbadger.com/images/ridibooks/ridiselect-apache-base "Get your own version badge on microbadger.com")

Usage
-----

Standalone usage example with host's current working directory as document root:
```
docker run -p 80:80 \
  -v $(pwd):/app/public \
  --name php-apache \
  -e PHP_XDEBUG_ENABLE=1 \
  ridibooks/ridiselect-apache-base
```

## Environment variables

#### System
- TIMEZONE (default: Asia/Seoul)

#### Apache
- APACHE_DOC_ROOT (default: /app/public)

#### XDebug
- PHP_XDEBUG_ENABLE
- PHP_XDEBUG_REMOTE_HOST (default: host.docker.internal)

#### Datadog
- DD_TRACE_ENABLED (default: 0)
- DD_SERVICE_NAME (default: ridiselect)
- DD_TRACE_ANALYTICS_ENABLED (default: false)
- DD_AGENT_HOST (default: localhost)
- DD_TRACE_AGENT_PORT (default: 8126)
- See more options: https://docs.datadoghq.com/tracing/setup/php/#environment-variable-configuration
