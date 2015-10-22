#import "SearchAcronymsController.h"
#import "NetworkClient.h"
#import <Blindside.h>
#import "AcronymsRepository.h"
#import "MBProgressHUD.h"
#import <KSPromise.h>
#import <MBProgressHUD.h>

@interface SearchAcronymsController ()<MBProgressHUDDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<BSInjector> injector;
@property (nonatomic) NSArray *tableData;
@property (nonatomic) AcronymsRepository *repository;
@property (nonatomic) MBProgressHUD *progressHUD;

@end


static NSString *const cellIdentifier = @"cellIdentifier";

@implementation SearchAcronymsController

+ (BSInitializer *)bsInitializer
{
    return [BSInitializer initializerWithClass:self
                                      selector:@selector(initWithAcronymRepository:)
                                  argumentKeys:[AcronymsRepository class],
                                                nil];
}

- (instancetype)initWithAcronymRepository:(AcronymsRepository *)acronymRepository {
    self = [super init];
    if (self)
    {
        self.repository = acronymRepository;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Search Acronyms";

    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.progressHUD];
    self.progressHUD.delegate = self;
    self.progressHUD.labelText = @"Fetching...";

}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [self.progressHUD removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UISearchBarDelegate>

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *trimmedString = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    KSPromise *promise = [self.repository getAllFullFormsFor:trimmedString];
    [self.progressHUD show:YES];

    [promise then:^id(NSArray *fullForms) {
        [self.progressHUD hide:YES];
        self.tableData = fullForms;
        [self.tableView reloadData];

        return nil;
    } error:^id (NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                        message:error.description
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [self.progressHUD hide:YES];
        [alert show];
        return nil;
    }];
}


#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tableData) {
        return [self.tableData count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.tableData[indexPath.row];
    return cell;
}

@end
