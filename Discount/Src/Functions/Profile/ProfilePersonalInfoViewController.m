//
//  ProfilePersonalInfoViewController.m
//  Discount
//
//  Created by fengfeng on 15/3/14.
//  Copyright (c) 2015年 wanjiahui. All rights reserved.
//

#import "ProfilePersonalInfoViewController.h"
#import "UIColor+SSExt.h"
#import "UserInfo.h"
#import "ProfileDataManager.h"
#import "VPImageCropperViewController.h"
#include "XXPickerView.h"
#import "ProfilePhoneViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface ProfilePersonalInfoViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, VPImageCropperDelegate>

@property(nonatomic, retain) UserInfo *userInfo;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@end

@implementation ProfilePersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupBackItem];

    self.userInfo = [ProfileDataManager userInfo:nil];
    if (!self.userInfo) {
        [self updateUserInfoFromNet];
    }else{
        [self configUserInfo];
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self updateUserInfoFromNet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUserInfo
{
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfo.avatar]];
    self.nickNameLabel.text = self.userInfo.nickName;
    self.sexLabel.text      = SEXSTRBY(self.userInfo.sex.integerValue);
    self.addressLabel.text  = ADDRSTRBY(self.userInfo.province, self.userInfo.city);
    self.phoneLabel.text    = self.userInfo.phone;
    //self.emailLabel.text    = self.userInfo.email;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", nil];
        [choiceSheet showInView:self.view];
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        NSArray *dataSource = @[@"男", @"女"];
        WEAKSELF(weakSelf);
        [self showPickViewWithDataSource:dataSource
                              completion:^(NSArray *selectIndex) {
                                  if ([selectIndex count]) {
                                      [MBProgressHUD showHUDAddedTo:weakSelf.view.window animated:YES];
                                      NSInteger index = [selectIndex[0] integerValue];
                                      [ProfileDataManager changeGender:dataSource[index] result:^(id data, NSError *error) {
                                          [MBProgressHUD hideHUDForView:weakSelf.view.window animated:YES];
                                          
                                          NSString *msg = nil;
                                          if (!error && data) {
                                              msg = data;
                                          }else{
                                              msg = MsgFromError(error);
                                          }
                                          
                                          [MBProgressHUD showTextHUDAddedTo:weakSelf.view.window withText:msg animated:YES];
                                          
                                          [weakSelf updateUserInfoFromNet];
                                          
                                      }];
                                  }
                                  
                              }];
    }else if (indexPath.section == 0 && indexPath.row == 3){
        WEAKSELF(weakSelf);
        NSArray *dataSource = [self loadCitysData];

        
        [self showPickViewWithDataSource:dataSource
                              completion:^(NSArray *selectIndex) {
                                  if ([selectIndex count] == 2) {
                                      [MBProgressHUD showHUDAddedTo:weakSelf.view.window animated:YES];
                                      NSInteger proviceIndex    = [selectIndex[0] integerValue];
                                      NSInteger cityIndex       = [selectIndex[1] integerValue];
                                      NSString *province = [dataSource[proviceIndex] allKeys][0];
                                      NSString *city = [dataSource[proviceIndex] allValues][0][cityIndex];
                                      [ProfileDataManager changeRegion:province city:city result:^(id data, NSError *error) {
                                          [MBProgressHUD hideHUDForView:weakSelf.view.window animated:YES];
                                          
                                          NSString *msg = nil;
                                          if (!error && data) {
                                              msg = data;
                                          }else{
                                              msg = MsgFromError(error);
                                          }
                                          
                                          [MBProgressHUD showTextHUDAddedTo:weakSelf.view.window withText:msg animated:YES];
                                          
                                          [weakSelf updateUserInfoFromNet];
                                          
                                      }];
                                  }
                              }];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0 && IsEmpty(self.userInfo.phone)){
        ProfilePhoneViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfilePhoneViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 SSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 SSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.avatarImageView.image = editedImage;
    WEAKSELF(weakSelf)
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        [MBProgressHUD showHUDAddedTo:weakSelf.view.window animated:YES];
        
        [ProfileDataManager uploadAvatarImage:editedImage result:^(id data, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:weakSelf.view.window animated:YES];
            
            NSString *msg = nil;
            if (data) {
                msg = data;
            }else{
                msg = MsgFromError(error);
            }
            
            [MBProgressHUD showTextHUDAddedTo:weakSelf.view.window withText:msg animated:YES];
            
            [weakSelf updateUserInfoFromNet];
        }];
        
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) SSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (void)updateUserInfoFromNet
{
    [ProfileDataManager userInfo:^(id data, NSError *error) {
        if (data && !error) {
            self.userInfo = data;
            [self configUserInfo];
        }
    }];
}


#pragma mark - cityData

- (void)showPickViewWithDataSource:(NSArray *)dataSource completion:(completeBlock)complete
{
    XXPickerView *pickerView = [[[NSBundle bundleForClass:[XXPickerView class ]] loadNibNamed:@"XXPickerView" owner:self options:nil] objectAtIndex:0];
    pickerView.frame = self.view.bounds;
    pickerView.dataSource = dataSource;
    pickerView.complete = complete;
    [self.view addSubview:pickerView];
}

- (NSArray *)loadCitysData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    NSData *provinceAndCityData = [NSData dataWithContentsOfFile:filePath];
    NSDictionary *provinceAndCitysDic = [NSJSONSerialization JSONObjectWithData:provinceAndCityData options:kNilOptions error:nil];
    
    NSMutableArray *dataSource = [NSMutableArray arrayWithCapacity:32];
    int i = 0;
    for (NSString *province in [provinceAndCitysDic allKeys]) {
        NSDictionary * citys = provinceAndCitysDic[province];
        dataSource[i++] = @{province:[citys allKeys]};
    }
    
    return dataSource;
    
}


@end
