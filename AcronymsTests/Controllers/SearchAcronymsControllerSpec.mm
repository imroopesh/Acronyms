#import <Cedar.h>
#import <Blindside.h>
#import "SearchAcronymsController.h"
#import "AcronymsRepository.h"
#import "InjectorProvider.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(SearchAcronymsControllerSpec)

describe(@"SearchAcronymsController", ^{
    __block SearchAcronymsController *subject;
    __block id<BSBinder, BSInjector>  injector;
    __block UINavigationController *navigationController;

    beforeEach(^{
        injector = (id)[InjectorProvider injector];
        subject = [injector getInstance:[SearchAcronymsController class]];
        navigationController = [[UINavigationController alloc] initWithRootViewController:subject];

    });

    describe(@"ViewDidLoad", ^{
        beforeEach(^{
            spy_on(subject.navigationController.view);
            subject.view should_not be_nil;
        });

        it(@"should set the Correct Title", ^{
            subject.title should equal(@"Search Acronyms");
        });

        it(@"should properly allocate Acronym repository", ^{
            subject.repository should be_instance_of([AcronymsRepository class]);
        });

        it(@"should Instantiate progressHUD", ^{
            subject.progressHUD should_not be_nil;
        });

        it(@"should Add progressHUD as a Subview of NavigationControllerView", ^{
            subject.navigationController.view should have_received(@selector(addSubview:)).with(subject.progressHUD);
        });
    });

    describe(@"As a <UISearchBarDelegate>", ^{
        __block UISearchBar *seachbar;

        beforeEach(^{
            seachbar = fake_for([UISearchBar class]);
            [injector bind:[UISearchBar class] toInstance:seachbar];

            seachbar stub_method(@selector(text)).and_return(@"FBI");

            subject.view should_not be_nil;
            spy_on(subject.repository);
            [subject searchBarSearchButtonClicked:seachbar];
        });

        it(@"should call getAllFullFormsFor on repository", ^{
            subject.repository should have_received(@selector(getAllFullFormsFor:)).with(@"FBI");
        });

    });
});

SPEC_END
