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
  -v $(pwd):/var/www/html \
  --name php-apache \
  -e XDEBUG_ENABLE=1 \
  ridibooks/ridiselect-apache-base
```
