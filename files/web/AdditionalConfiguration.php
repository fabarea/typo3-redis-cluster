<?php

$TYPO3_CONF_VARS['SYS']['trustedHostsPattern'] =".*";

// Development settings
$GLOBALS['TYPO3_CONF_VARS']['SYS']['sqlDebug'] = 1;
$GLOBALS['TYPO3_CONF_VARS']['FE']['debug'] = 1;
$GLOBALS['TYPO3_CONF_VARS']['BE']['debug'] = 1;
$GLOBALS['TYPO3_CONF_VARS']['SYS']['displayErrors'] = '1';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['devIPmask'] = '*';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['errorHandler'] = 'TYPO3\\CMS\\Core\\Error\\ErrorHandler';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['errorHandlerErrors'] = E_ALL ^ E_NOTICE;
$GLOBALS['TYPO3_CONF_VARS']['SYS']['exceptionalErrors'] = E_ALL ^ E_NOTICE ^ E_WARNING ^ E_USER_ERROR ^ E_USER_NOTICE ^ E_USER_WARNING;
$GLOBALS['TYPO3_CONF_VARS']['SYS']['debugExceptionHandler'] = 'TYPO3\\CMS\\Core\\Error\\DebugExceptionHandler';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['productionExceptionHandler'] = 'TYPO3\\CMS\\Core\\Error\\DebugExceptionHandler';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['systemLogLevel'] = '0';
$GLOBALS['TYPO3_CONF_VARS']['SYS']['systemLog'] = true;

if (getenv('REDIS_HOST')) {
    $redisCaches = [
        'assets',
        'extbase',
        'l10n',

        // 'cache_imagesizes',
        // 'cache_hash',
        // 'cache_pages',
        // 'cache_pagesection',
        // 'cache_rootline',
        // 'extbase_reflection',
        // 'extbase_datamapfactory_datamap',
        // 'ttaddress_geocoding',
        // 'tx_solr_configuration'
    ];

    $redisDatabaseNumber = 0;
    foreach ($redisCaches as $cacheName) {
        $GLOBALS['TYPO3_CONF_VARS']['SYS']['caching']['cacheConfigurations'][$cacheName]['backend'] = \TYPO3\CMS\Core\Cache\Backend\RedisBackend::class;
        $GLOBALS['TYPO3_CONF_VARS']['SYS']['caching']['cacheConfigurations'][$cacheName]['options'] = [
            'database' => $redisDatabaseNumber++,
            'defaultLifetime' => 2592000, // 86400 * 30 = 30 days
            'hostname' => getenv('REDIS_HOST') ?? 'redis',
            'password' => getenv('REDIS_PASSWORD') ?? '',
            'port' => getenv('REDIS_PORT') ?? 6379
        ];
    }

    $GLOBALS['TYPO3_CONF_VARS']['SYS']['locking']['redis'] = [
        'database' => $redisDatabaseNumber++,
        'hostname' => getenv('REDIS_HOST') ?? 'redis'
    ];
}
