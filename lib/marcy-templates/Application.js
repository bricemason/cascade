Ext.define('MyApp.Application', {
    extend : 'Marcy.app.Application',

    bootstrap : function(launchType) {
        if (launchType === 'launch') {
            Ext.Viewport.add({
                xtype : 'main'
            });
        }
    }
});