<?php

$TYPO3_CONF_VARS['SYS']['trustedHostsPattern'] =".*";

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
