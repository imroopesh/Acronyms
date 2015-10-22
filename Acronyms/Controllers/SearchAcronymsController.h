#import <UIKit/UIKit.h>
@class AcronymsRepository;
@class MBProgressHUD;

@interface SearchAcronymsController : UIViewController <UISearchBarDelegate, UITableViewDataSource>


@property (weak, nonatomic, readonly) UISearchBar *searchBar;
@property (weak, nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) AcronymsRepository *repository;
@property (nonatomic, readonly) MBProgressHUD *progressHUD;


- (instancetype)initWithAcronymRepository:(AcronymsRepository *)acronymRepository;
@end

