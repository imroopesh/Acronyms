#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@class Deserializer;

@interface NetworkClient : AFHTTPSessionManager

@property (nonatomic, readonly) Deserializer *deserializer;
@property (nonatomic, readonly) NetworkClient *networkClient;

- (void)getFullFormForAcronym:(NSString *)acronym
                      success:(void (^)(NSURLSessionDataTask *, NSArray *))success
                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end
