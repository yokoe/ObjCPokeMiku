#import <Foundation/Foundation.h>

/**
 * PMMIDIUtil provides lower level APIs to access NSX-39.
 */
@interface PMMIDIUtil : NSObject

/**
 * Returns a MIDIDeviceRef of online NSX-39. Returns 0 when there is no online NSX-39.
 */
+ (MIDIDeviceRef)connectedNSX39Device;

/**
 * Returns a MIDIEndpointRef of specified NSX-39.
 */
+ (MIDIEndpointRef)endpointOfDevice:(MIDIDeviceRef)deviceRef;

/**
 * Returns a MIDIPortRef of newly created output port.
 */
+ (MIDIPortRef)createOutputPort;

+ (OSStatus)sendNoteOnToDestination:(MIDIEndpointRef)destination outputPort:(MIDIPortRef)outputPort key:(int)key velocity:(int)velocity;
+ (OSStatus)sendSwitchPronunciationToDestination:(MIDIEndpointRef)destination outputPort:(MIDIPortRef)outputPort pronunciation:(Byte)pronunciationCode;
@end
