#import <Foundation/Foundation.h>

@interface Deserializer : NSObject

- (NSArray *) deserialize:(NSDictionary *)jsonDictionary;
@end
