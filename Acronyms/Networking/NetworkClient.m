#import "NetworkClient.h"
#import "Deserializer.h"
#import <Blindside.h>

@interface NetworkClient()

@property (nonatomic) Deserializer *deserializer;
@property (nonatomic) NetworkClient *networkClient;

@end

@implementation NetworkClient

+(BSInitializer *)bsInitializer
{
    return [BSInitializer initializerWithClass:self
                                      selector:@selector(initWithDeserializer:)
                                  argumentKeys:[Deserializer class], nil];
}

- (instancetype)initWithDeserializer:(Deserializer *)deserializer
{
    self = [super init];
    if (self) {
        self.deserializer = deserializer;
        self.networkClient = [[NetworkClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://www.nactem.ac.uk"]];
    }
    return self;
}

- (void)getFullFormForAcronym:(NSString *)acronym
                      success:(void (^)(NSURLSessionDataTask *, NSArray *))success
                      failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSDictionary *params = @{ @"sf" :   acronym };
    
    [self.networkClient GET:@"/software/acromine/dictionary.py" parameters:params
                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                 if (responseObject == [NSNull null]) {
                                     return;
                                 }

                                 NSArray *acronymFullForms = [self.deserializer deserialize:[responseObject firstObject]];
                                 success(task, acronymFullForms);
                             }
                             failure:^(NSURLSessionDataTask *dataTask, NSError *error) {
                                 failure(dataTask, error);
                             }];
}


@end
