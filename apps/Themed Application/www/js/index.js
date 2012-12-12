
var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    
    // Bind Event Listeners
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    
    // deviceready Event Handler
    
    onDeviceReady: function() {
        console.log('deviceready');
        
        var callback = app.receivedFrequency;
        window.pitchDetection.registerFrequency( "18000", callback );
        window.pitchDetection.registerFrequency( "18200", callback );
        window.pitchDetection.registerFrequency( "18400", callback );
        window.pitchDetection.registerFrequency( "18600", callback );
        window.pitchDetection.registerFrequency( "18800", callback );
        window.pitchDetection.startListener();
    },

    receivedFrequency: function(frequency) {
        var templateId = frequency + "template";
        var templateHTML = document.getElementById( templateId).innerHTML;
        window.scrollTo(0, 0);
        document.getElementById( "content" ).innerHTML = templateHTML;
    }
};
