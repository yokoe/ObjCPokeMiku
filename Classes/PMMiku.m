#import "PMMiku.h"

#import <CoreMIDI/CoreMIDI.h>

#import "PMMIDIUtil.h"

@interface PMMiku() {
    MIDIEndpointRef destinationEndPointRef;
    MIDIPortRef outputPortRef;
    Byte currentKey;
}
@end

@implementation PMMiku

- (instancetype)init
{
    self = [super init];
    if (self) {
        MIDIDeviceRef connectedDeviceRef = [PMMIDIUtil connectedNSX39Device];
        if (connectedDeviceRef == 0) {
            NSLog(@"Error: Device not found");
            return nil;
        }
        
        destinationEndPointRef = [PMMIDIUtil endpointOfDevice:connectedDeviceRef];
        if (destinationEndPointRef == 0) {
            NSLog(@"Error: Failed to get destination end point.");
            return nil;
        }
        
        outputPortRef = [PMMIDIUtil createOutputPort];
        if (outputPortRef == 0) {
            NSLog(@"Error: Failed to create output port.");
            return nil;
        }
    }
    return self;
}

- (NSError *)noteOnWithKey:(Byte)key velocity:(Byte)velocity {
    OSStatus error = [PMMIDIUtil sendNoteOnToDestination:destinationEndPointRef outputPort:outputPortRef key:key velocity:velocity];
    if (error != noErr) {
        return nil; // TODO: Return NSError object.
    } else {
        currentKey = key;
        return nil;
    }
}

- (NSError *)noteOff {
    return [self noteOnWithKey:currentKey velocity:0];
}

- (NSError *)selectPronunciationCode:(Byte)pronunciationCode {
    OSStatus error = [PMMIDIUtil sendSwitchPronunciationToDestination:destinationEndPointRef outputPort:outputPortRef pronunciation:pronunciationCode];
    if (error != noErr) {
        return nil; // TODO: Return NSError object.
    } else {
        return nil;
    }
}

@end
