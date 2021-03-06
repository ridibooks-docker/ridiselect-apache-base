<?php

function testExtensions()
{
    $expects = [
        'curl',
        'mbstring',
        'PDO',
        'pdo_mysql',
    ];

    if (!empty(getenv('PHP_XDEBUG_ENABLE'))) {
        $expects[] = 'xdebug';
    }

    $actuals = get_loaded_extensions();

    $diff = array_diff($expects, $actuals);
    if ($diff) {
        echo "Following extensions are not loaded." . PHP_EOL;
        var_dump($diff);
        exit(1);
    }
}

function testDefaultTimezone()
{
    $expect = 'Asia/Seoul';
    $actual = date_default_timezone_get();

    if ($expect != $actual) {
        echo "Default timezone is $actual" . PHP_EOL;
        exit(1);
    }
}

testDefaultTimezone();
testExtensions();
