//
//  CDVPitchDetection.m
//  Basic_Audio_Watermarks
//
//  Created by Andrew Trice on 12/4/12.
//
//

#import "CDVPitchDetection.h"

@implementation CDVPitchDetection

@synthesize isListening;
@synthesize	rioRef;
@synthesize currentFrequency;


- (CDVPlugin*)initWithWebView:(UIWebView*)theWebView
{
    self = [super initWithWebView:theWebView];
    if (self) {
        self.registeredFrequencies = [[NSMutableArray alloc] init]; 
        self.rioRef = [RIOInterface sharedInstance];
        [rioRef setSampleRate:44100];
        [rioRef setFrequency:294];
        [rioRef initializeAudioSession];
    }
    return self;
}


- (void)startListener:(CDVInvokedUrlCommand*)command {
    isListening = YES;
	[rioRef startListening:self];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"listener started"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)stopListener:(CDVInvokedUrlCommand*)command {
    isListening = NO;
	[rioRef stopListening];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"listener stopped"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)registerFrequency:(CDVInvokedUrlCommand*)command {
    NSString *frequencyString = [command.arguments objectAtIndex:0];
    float frequency = [frequencyString floatValue];
    BOOL found = FALSE;
    
    for (int x = 0; x < [self.registeredFrequencies count]; x++) {
        float _frequency = [[self.registeredFrequencies objectAtIndex:x] floatValue];
        
        if ( _frequency == frequency ) {
            found = TRUE;
        }
    }
    
    if ( !found ) {
        [self.registeredFrequencies addObject:frequencyString];
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"frequency registered"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)unregisterFrequency:(CDVInvokedUrlCommand*)command {
    NSString* frequency = [command.arguments objectAtIndex:0];
    //TODO
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"frequency unregistered"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}




// This method gets called by the rendering function. Do something with the new frequency
- (void)frequencyChangedWithValue:(float)newFrequency{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
	//NSLog( @"frequencyChangedWithValue: %f", self.currentFrequency );
	
    int x = 0;
    float buffer = 100;
    for (x = 0; x < [self.registeredFrequencies count]; x++) {
        float frequency = [[self.registeredFrequencies objectAtIndex:x] floatValue];
        float minFrequency = frequency - buffer;
        float maxFrequency = frequency + buffer;
        
        if ( newFrequency >= minFrequency && newFrequency <= maxFrequency ) {
            self.currentFrequency = frequency;
            [self performSelectorOnMainThread:@selector(updateFrequency) withObject:nil waitUntilDone:NO];
            break;
        }
    }
    
    
    
	[pool drain];
	pool = nil;
	
}

- (void)updateFrequency {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    NSString *js = [NSString stringWithFormat:@"window.pitchDetection.executeCallback('%f')", self.currentFrequency];
    
    [self.webView stringByEvaluatingJavaScriptFromString:js];
	[pool drain];
	pool = nil;

}

@end
