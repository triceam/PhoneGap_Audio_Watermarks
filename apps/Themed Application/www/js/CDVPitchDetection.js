window.pitchDetection = {

    frequencyMap: {},
    lastFrequency: "",

    registerFrequency: function ( frequency, callback, success, fail) {
        if ( cordova.exec ) {
            console.log("registerFrequency  " + frequency);
            var freq = frequency.toString();
            this.frequencyMap[ freq ] = callback;
            cordova.exec(success, fail, "CDVPitchDetection", "registerFrequency", [freq]);    }
    },

    startListener: function (success, fail) {
        console.log( "startListener "  );
        if ( cordova.exec ) {
            cordova.exec(success, fail, "CDVPitchDetection", "startListener", [""]);
        }
    },

    stopListener: function (success, fail) {
        if ( cordova.exec ) {
            cordova.exec(success, fail, "CDVPitchDetection", "stopListener", [""]);
        }
    },

    executeCallback: function (frequency) {
        var freq = parseInt(frequency).toString();
        if ( freq != this.lastFrequency ) {
            this.lastFrequency = freq;
            var callback = this.frequencyMap[ freq ];
            if ( callback != undefined ) {
                callback( freq );
            }
        }
    }

    
};