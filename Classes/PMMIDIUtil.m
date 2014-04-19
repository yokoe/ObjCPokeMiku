#import <CoreMIDI/CoreMIDI.h>

#import "PMMIDIUtil.h"

@implementation PMMIDIUtil
+ (MIDIDeviceRef)connectedNSX39Device {
    ItemCount deviceCount = MIDIGetNumberOfDevices();
    for (ItemCount i = 0 ; i < deviceCount ; i++) {
        MIDIDeviceRef deviceRef = MIDIGetDevice(i);
        
        CFStringRef deviceNameCF = nil;
        if (noErr == MIDIObjectGetStringProperty(deviceRef, kMIDIPropertyName, &deviceNameCF)) {
            NSString *deviceName = [NSString stringWithString:(__bridge NSString *)deviceNameCF];
            CFRelease(deviceNameCF);
            NSLog(@"Device: %@", deviceName);
            if ([deviceName hasPrefix:@"NSX-39"]) {
                SInt32 isOffline = 0;
                MIDIObjectGetIntegerProperty(deviceRef, kMIDIPropertyOffline, &isOffline);
                if (isOffline == 0) {
                    return deviceRef;
                }
            }
        }
    }
    return 0;
}

+ (MIDIEndpointRef)endpointOfDevice:(MIDIDeviceRef)deviceRef {
    ItemCount entitiesCount = MIDIDeviceGetNumberOfEntities(deviceRef);
    if (entitiesCount != 1) {
        NSLog(@"NSX-39 should have 1 entity but got %ld.", entitiesCount);
        return 0;
    }
    
    MIDIEntityRef entityRef = MIDIDeviceGetEntity(deviceRef, 0);
    if (!entityRef) {
        NSLog(@"Error: Cannot find entity.");
        return 0;
    }
    
    ItemCount destinationsCount = MIDIEntityGetNumberOfDestinations(entityRef);
    if (destinationsCount != 1) {
        NSLog(@"NSX-39 should have 1 destination but got %ld.", destinationsCount);
        return 0;
    }
    
    return MIDIEntityGetDestination(entityRef, 0);
}

+ (MIDIPortRef)createOutputPort {
    OSStatus error;
    
    MIDIClientRef clientRef;
    error = MIDIClientCreate((__bridge CFStringRef)@"client", NULL, NULL, &clientRef);
    if (error != noErr) {
        NSLog(@"Failed to create MIDIClient. Code: %d", (int)error);
        return 0;
    }
    
    MIDIPortRef outputPortRef;
    error = MIDIOutputPortCreate(clientRef, (__bridge CFStringRef)@"outputPort", &outputPortRef);
    if (error != noErr) {
        NSLog(@"Failed to create MIDIOutputPort. Code: %d", (int)error);
        return 0;
    }
    
    return outputPortRef;
}

+ (OSStatus)sendNoteOnToDestination:(MIDIEndpointRef)destinationEndPointRef outputPort:(MIDIPortRef)outputPortRef key:(int)key velocity:(int)velocity {
    MIDIPacketList packetList;
    packetList.numPackets = 1;
    
    MIDIPacket* packet = &packetList.packet[0];
    packet->timeStamp = 0;
    packet->length = 3;
    packet->data[0] = 0x90;
    packet->data[1] = key;
    packet->data[2] = velocity;
    
    return MIDISend(outputPortRef, destinationEndPointRef, &packetList);
}
+ (OSStatus)sendSwitchPronunciationToDestination:(MIDIEndpointRef)destinationEndPointRef outputPort:(MIDIPortRef)outputPortRef pronunciation:(Byte)pronunciationCode {
    MIDIPacketList packetList;
    packetList.numPackets = 1;
    
    MIDIPacket* packet = &packetList.packet[0];
    packet->timeStamp = 0;
    packet->length = 9;
    packet->data[0] = 0xF0;
    packet->data[1] = 0x43;
    packet->data[2] = 0x79;
    packet->data[3] = 0x09;
    packet->data[4] = 0x11;
    packet->data[5] = 0x0A;
    packet->data[6] = 0x00;
    packet->data[7] = pronunciationCode;
    packet->data[8] = 0xF7;
    
    return MIDISend(outputPortRef, destinationEndPointRef, &packetList);
}
@end
