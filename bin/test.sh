#!/usr/bin/env bash

set -e

RESULT=0

function run_test()
{
    if [[ "${1}" == "with XDEBUG" ]]
    then
        echo "Run test with XDEBUG.."
        docker run -d --rm \
            --name apache-test \
            -v $(pwd)/test:/test \
            -e PHP_XDEBUG_ENABLE=1 \
            -p 8000:80 \
            ridiselect-apache-base:latest >/dev/null 2>&1
    else
        echo "Run test without XDEBUG.."
        docker run -d --rm \
            --name apache-test \
            -v $(pwd)/test:/test \
            -p 8000:80 \
            ridiselect-apache-base:latest >/dev/null 2>&1
    fi

    if ! test_php_configuration
    then
        echo "test_php_configuration failed.." >&2
        RESULT=1
    fi

    if ! test_web
    then
        echo "test_web failed.." >&2
        RESULT=1
    fi

    docker stop apache-test >/dev/null 2>&1
}

function test_php_configuration()
{
    docker exec -t apache-test bash -c "php /test/PHPTest.php"
}

function test_web()
{
    curl -sS localhost:8000/health.php | grep -Eq '^localhost$'
}



run_test "without XDEBUG"
run_test "with XDEBUG"

exit ${RESULT:-0}
