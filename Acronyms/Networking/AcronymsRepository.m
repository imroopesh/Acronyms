#import "AcronymsRepository.h"
#import <Blindside.h>
#import "NetworkClient.h"
#import <KSDeferred.h>
#import <KSPromise.h>

@interface AcronymsRepository()

@property (nonatomic) NetworkClient *client;

@end

@implementation AcronymsRepository

+(BSInitializer *)bsInitializer
{
    return [BSInitializer initializerWithClass:self selector:@selector(initWithNetworkClient:)
                                  argumentKeys:[NetworkClient class], nil];
}

- (instancetype)initWithNetworkClient:(NetworkClient *)client
{
    self = [super init];
    if (self) {
        self.client = client;
    }
    return self;
}


- (KSPromise *) getAllFullFormsFor:(NSString *)acronym
{
    KSDeferred *deferred = [[KSDeferred alloc] init];

    [self.client getFullFormForAcronym:acronym
                               success:^(NSURLSessionDataTask *task, NSArray *fullforms) {

                                   [deferred resolveWithValue:fullforms];

                               } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                   
                                   [deferred rejectWithError:error];
                               }];
    return deferred.promise;
}

@end
