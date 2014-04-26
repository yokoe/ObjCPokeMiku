#import "PMMiku.h"

#import <CoreMIDI/CoreMIDI.h>

#import "PMMIDIUtil.h"

@interface PMMiku() {
    MIDIEndpointRef destinationEndPointRef;
    MIDIPortRef outputPortRef;
    Byte currentKey;
    NSDictionary *charMap;
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
        
        NSMutableDictionary *charMap_ = @{}.mutableCopy;
        NSError *error = nil;
        NSString *charsList = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pm-char-map" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
        int lineIndex = 0;
        for (NSString *character in [charsList componentsSeparatedByString:@"\n"]) {
            charMap_[character] = @(lineIndex);
            lineIndex++;
        }
        charMap = charMap_;
    }
    return self;
}

- (NSError *)noteOnWithKey:(Byte)key velocity:(Byte)velocity pronunciation:(NSString *)pronunciation {
    NSError *error = [self selectPronunciation:pronunciation];
    if (error == nil) {
        return [self noteOnWithKey:key velocity:velocity];
    } else {
        return error;
    }
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

- (NSError *)selectPronunciation:(NSString *)pronunciation {
    NSNumber *pronunciationCode = charMap[pronunciation];
    if (pronunciationCode != nil) {
        return [self selectPronunciationCode:pronunciationCode.intValue];
    } else {
        NSLog(@"%@ not found in table.", pronunciation);
        // TODO: Return an error
        return nil;
    }
}

@end
