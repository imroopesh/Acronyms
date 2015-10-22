#import "Cedar.h"
#import "AcronymsRepository.h"
#import <Blindside.h>
#import <InjectorProvider.h>
#import <KSPromise.h>
#import <NetworkClient.h>

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(AcronymsRepositorySpec)

describe(@"AcronymsRepository", ^{
    __block AcronymsRepository *subject;
    __block id<BSBinder, BSInjector> injector;

    beforeEach(^{
        injector = (id) [InjectorProvider injector];
        subject = [injector getInstance:[AcronymsRepository class]];
    });

    describe(@"initWithNetworkClient", ^{
        __block NSString *acronym = @"FBI";
        __block KSPromise *promise;

        beforeEach(^{
            spy_on(subject.client);
            promise = [subject getAllFullFormsFor:acronym];
        });

        it(@"should return a promise", ^{
            promise should be_instance_of([KSPromise class]);
        });

        it(@"should call getFullFormForAcronym on client", ^{
            subject.client should have_received(@selector(getFullFormForAcronym:success:failure:));
        });
    });

});

SPEC_END
