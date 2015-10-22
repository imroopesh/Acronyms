#import "NetworkClient.h"
#import <Blindside.h>
#import "Cedar.h"
#import <InjectorProvider.h>
#import <KSDeferred.h>
#import <AFHTTPSessionManager.h>

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(NetworkClientSpec)

describe(@"NetworkClient", ^{
    __block NetworkClient *subject;
    __block id<BSInjector, BSInjector> injector;

    beforeEach(^{
        injector = [InjectorProvider injector];
        subject = [injector getInstance:[NetworkClient class]];
    });

    describe(@"getFullFormForAcronym", ^{
        __block NSString *acronym = @"FBI";
        __block KSDeferred *deferred;

        beforeEach(^{
            deferred = [injector getInstance:[KSDeferred class]];
            spy_on(subject.networkClient);
            [subject getFullFormForAcronym:acronym
                                       success:^(NSURLSessionDataTask *task, NSArray *fullforms) {
                                           [deferred resolveWithValue:fullforms];
                                       } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                           [deferred rejectWithError:error];
                                       }];
        });

        it(@"should call GET on networkClinet", ^{
            subject.networkClient should have_received(@selector(GET:parameters:success:failure:));
        });
    });

});

SPEC_END
