#import <Foundation/Foundation.h>

@interface PMMiku : NSObject
- (NSError *)noteOnWithKey:(Byte)key velocity:(Byte)velocity pronunciation:(NSString *)pronunciation;
- (NSError *)noteOnWithKey:(Byte)key velocity:(Byte)velocity;
- (NSError *)noteOff;
- (NSError *)selectPronunciationCode:(Byte)pronunciationCode;
- (NSError *)selectPronunciation:(NSString *)pronunciation;
@end
