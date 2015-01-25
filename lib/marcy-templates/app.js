Ext.syncRequire('Marcy.Framework');

Ext.application({
    name        : 'MyApp',
    application : 'MyApp.Application',

    requires : [
        'MyApp.Application'
    ],

    views : [
        'Main'
    ]
});