//
//  CDVPitchDetection.h
//  Basic_Audio_Watermarks
//
//  Created by Andrew Trice on 12/4/12.
//
//

#import <Cordova/CDVPlugin.h>
#import "RIOInterface.h"

@class RIOInterface;

@interface CDVPitchDetection : CDVPlugin {
    
	BOOL isListening;
	RIOInterface *rioRef;
	float currentFrequency;
    NSMutableArray* registeredFrequencies;
}



@property(nonatomic, assign) RIOInterface *rioRef;
@property(nonatomic, assign) float currentFrequency;
@property(assign) BOOL isListening;
@property(nonatomic, assign) NSMutableArray *registeredFrequencies;

- (void)startListener:(CDVInvokedUrlCommand*)command;
- (void)stopListener:(CDVInvokedUrlCommand*)command;


- (void)frequencyChangedWithValue:(float)newFrequency;
- (void)updateFrequency;

@end
