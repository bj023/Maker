//
//  AboutViewController.m
//  Discount
//
//  Created by jackyzeng on 3/22/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "AboutViewController.h"
#import "BaseNavigationController.h"
#import "UserAgreementViewController.h"

static CGFloat const kVersionCellHeight = 226.0f;
static CGFloat const kWechatCellHeight = 60.0f;

@interface AboutViewController ()

@property(nonatomic, strong) IBOutlet UIImageView *iconImageView;
@property(nonatomic, strong) IBOutlet UILabel *versionLabel;

@end

@implementation AboutViewController

- (void)setupAboutBackItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"common_back"] style:UIBarButtonItemStylePlain target:self action:@selector(aboutBackItemClicked)];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
}


- (void)aboutBackItemClicked {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAboutBackItem];
    
    self.iconImageView.image = [UIImage imageNamed:@"AppIcon60x60"];
    
    NSString *version =  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    self.versionLabel.text = [NSString stringWithFormat:@"版本 %@", version];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return kVersionCellHeight;
            break;
            
        case 1:
            return kWechatCellHeight;
            
        case 2: {
            CGFloat offsetY = kVersionCellHeight + kWechatCellHeight;
            if (self.navigationController.navigationBar.translucent) {
                offsetY += NAVIGATIONBAR_HEIGHT + STATUSBAR_HEIGHT;
            }
            return self.tableView.frame.size.height - offsetY;
        }
            break;
            
        default:
            return kWechatCellHeight;
            break;
    }
}

- (BOOL)enableCustomBackground {
    return NO;
}

- (IBAction)onUserAgreement:(id)sender {
    UserAgreementViewController *agreeController = [UserAgreementViewController new];
    [self pushViewControllerInNavgation:agreeController animated:YES];
}

@end
