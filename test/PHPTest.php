<?php

function testExtensions()
{
    $expects = [
        'apcu',
        'bcmath',
        'curl',
        'mbstring',
        'mcrypt',
        'PDO',
        'pdo_mysql',
        'xdebug',
        'xml',
        'zip',
    ];

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
