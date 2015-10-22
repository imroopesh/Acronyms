#import <Foundation/Foundation.h>
@class KSPromise;
@class NetworkClient;

@interface AcronymsRepository : NSObject

@property (nonatomic, readonly) NetworkClient *client;

- (KSPromise *) getAllFullFormsFor:(NSString *)acronym;

@end
