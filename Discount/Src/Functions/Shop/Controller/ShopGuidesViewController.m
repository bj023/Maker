//
//  ShopGuidesViewController.m
//  Discount
//
//  Created by jackyzeng on 3/12/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopGuidesViewController.h"
#import "ShopGuideButton.h"
#import "ShopDataManager.h"
#import "TapDetectingImageView.h"
#import "ShopGuideServiceButton.h"
#import "NSDictionary+SSJSON.h"

#define ZOOM_STEP 1.5f
#define MAXIUM_ZOOMSCALE 3.0f
#define SHOP_GUIDE_TEST 1

#define kFloorTag 100

CGFloat const kButtonTopSpacing     = 25.0f;
CGFloat const kButtonLeftSpacing    = 10.0f;
CGFloat const kButtonRightSpacing   = 10.0f;
CGFloat const kButtonSize           = 60.0f;
CGFloat const kButtonItemSpacing    = 10.0f;

CGFloat const kButtomPadding = 10;
CGFloat const kButtomSizeH = 40;
CGFloat const kButtonTopH = 98/2;
CGFloat const kButtomViewH = 200 + kButtonTopH;

@interface ServiceMarkImageView : UIImageView

@end


@implementation ServiceMarkImageView

@end

@interface ShopGuidesViewController () <UIScrollViewDelegate, TapDetectingImageViewDelegate>
{
    BOOL _isShow;
}
@property(nonatomic, strong) NSMutableArray *serviceButtons;
@property(nonatomic, strong) NSMutableArray *floorButtons;

@property(nonatomic, strong) UIScrollView *serviceScrollView;
@property(nonatomic, strong) UIScrollView *floorScrollView;

@property(nonatomic, strong) LocateBase *locate;
@property(nonatomic) CGFloat minimumZoomScale; // not equal to self.scrollView.minimumZoomScale

@property(nonatomic, strong) UIView *buttomView;

@property(nonatomic, strong)NSDictionary *floorsDic;
@property(nonatomic, strong)NSArray *floorsArr;

@property(nonatomic, strong)NSDictionary *serviceDic;
@property(nonatomic, strong)NSArray *serviceArr;

@property(nonatomic, strong)NSDictionary *coordsDic;
@property(nonatomic, strong)NSArray *coordsArr;

@property(nonatomic, strong)NSString *currentFloor;
@property(nonatomic, strong)NSString *imgUrl;
@property(nonatomic, assign)int width;
@property(nonatomic, assign)int height;

- (void)centerScrollViewContents;
//- (void)markService:(ShopGuideServiceType)serviceType at:(CGPoint)location;

@end

@implementation ShopGuidesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _serviceButtons = [NSMutableArray array];
    _floorButtons = [NSMutableArray array];
    
    [self.scrollView setBouncesZoom:YES];
    self.scrollView.maximumZoomScale = MAXIUM_ZOOMSCALE;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // add touch-sensitive image view to the scroll view
    self.imageView = [[TapDetectingImageView alloc] initWithFrame:self.view.bounds];
    [self.imageView setDelegate:self];
    [self.scrollView setContentSize:[self.imageView frame].size];
    self.imageView.center = self.scrollView.center;
    [self.scrollView addSubview:self.imageView];
    
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    float minimumScale = [self.scrollView frame].size.width  / [self.imageView frame].size.width;
    [self.scrollView setMinimumZoomScale:minimumScale];
}

- (void)clickFindLocationWithBrandID:(NSNumber *)brandID Floor:(NSString *)floor
{
    SSLog(@"brandID:%@->floor:%@",brandID,floor);
    //从品牌详情页，点击位置查找接口
    AFHTTPRequestOperation *op = [NetAPI operationForLocateBrandWithShopID:self.shopID brandID:brandID floor:floor success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        SSLog(@"%@",[data objectForKey:@"data"]);

        if ([[data stringForKey:@"code"] isEqualToString:@"000000"]) {
            [self loadMapViewWithDictionary:[data dictionaryForKey:@"data"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [op start];
}

- (void)clickFindLocationWithServiceID:(NSNumber*)serviceID Floor:(NSString *)floor
{
    SSLog(@"serviceID:%@->floor:%@",serviceID,floor);
    //从退税详情页，点击位置查找接口：
    AFHTTPRequestOperation *op = [NetAPI operationForLocateServiceWithShopID:self.shopID serviceID:serviceID floor:floor success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        SSLog(@"%@",[data objectForKey:@"data"]);
        if ([[data stringForKey:@"code"] isEqualToString:@"000000"]) {
            [self loadMapViewWithDictionary:[data dictionaryForKey:@"data"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [op start];
}

// 从导购直接进入
- (void)clickFindLocation
{
    //直接点击导购接口：
    AFHTTPRequestOperation *op = [NetAPI operationForLocateServiceWithShopID:self.shopID serviceID:nil floor:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithJsonString:operation.responseString];
        SSLog(@"%@->%@",[dic objectForKey:@"data"],[data objectForKey:@"data"]);
        if ([[data stringForKey:@"code"] isEqualToString:@"000000"]) {
            [self loadMapViewWithDictionary:[data dictionaryForKey:@"data"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [op start];
}

- (void)requestBrandByFloor:(NSString *)floor
{
    //点击底部购物区域
    AFHTTPRequestOperation *op = [NetAPI operationForLocateServiceWithShopID:self.shopID serviceID:nil floor:floor success:^(AFHTTPRequestOperation *operation, NSDictionary *data) {
        SSLog(@"%@",[data objectForKey:@"data"]);
        
        for (UIView *subview in [self.imageView subviews]) {
            if ([subview isKindOfClass:[ServiceMarkImageView class]]) {
                [subview removeFromSuperview];
            }else if ([subview isKindOfClass:[UIImageView class]]){
                [subview removeFromSuperview];
            }
        }
        
        if ([[data stringForKey:@"code"] isEqualToString:@"000000"]) {
            [self loadMapViewWithDictionary:[data dictionaryForKey:@"data"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [op start];
}

#pragma -mark 滚动

- (void)centerScrollViewContents {
    
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

- (void)configImageViewForSize:(CGSize)size {
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    
    CGFloat minimumScale = MIN([self.scrollView frame].size.width / width, [self.scrollView frame].size.height / height);
    self.minimumZoomScale = minimumScale;
    CGFloat w = width * minimumScale;
    CGFloat h = height * minimumScale;
    self.scrollView.contentSize = CGSizeMake(w, h);
    self.scrollView.minimumZoomScale = 1.0f;
    self.scrollView.maximumZoomScale = MAXIUM_ZOOMSCALE / minimumScale;
    
    CGRect imageFrame = self.imageView.frame;
    imageFrame.size.width = w;
    imageFrame.size.height = h;
    if(self.imgUrl)
        self.imageView.frame = imageFrame;
    
    [self centerScrollViewContents];
}


- (NSArray *)sortedFloorsArray:(NSDictionary *)floorsDict
{
    NSArray *keys = [floorsDict allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *floor1 = (NSNumber *)obj1;
        NSNumber *floor2 = (NSNumber *)obj2;
        return [floor1 compare:floor2];
    }];
    return sortedKeys;
}

- (NSArray *)floorsArray:(NSDictionary *)floorsDict
{
    NSArray *keys = [floorsDict allKeys];
    return keys;
}

#pragma -mark 加载地图
#pragma -mark ------------------------------------------------------------------------------------
- (void)loadMapViewWithDictionary:(NSDictionary *)dic
{
    

    //    NSDictionary *dic = [data dictionaryForKey:@"data"];
    self.imgUrl = [dic stringForKey:@"img"];
    self.currentFloor = [dic stringForKey:@"floor"];
    self.width = [[dic stringForKey:@"width"] intValue];
    self.height = [[dic stringForKey:@"height"] intValue];
    self.floorsDic = [dic dictionaryForKey:@"floors"];
    self.coordsDic = [dic objectForKey:@"coords"];
    self.serviceDic = [dic dictionaryForKey:@"services"];
    
    self.coordsArr = (NSArray *)self.coordsDic;
    self.floorsArr = [self floorsArray:self.floorsDic];
    self.serviceArr = [self sortedFloorsArray:self.serviceDic];


    [self configImageViewForSize:CGSizeMake(self.width, self.height)];
    
    if (self.coordsArr.count>0) {
        // 定位
        [self markBrands];
    }
    
    [self setUpService_Buttons];
    [self setUpFloors_Buttons];
    
    WEAKSELF(weakSelf);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                 [weakSelf configImageViewForSize:image.size];
                             }];
}

- (void)markBrands
{
    
    
    CGPoint point = CGPointZero;

    //CGFloat  scale = self.minimumZoomScale * self.scrollView.zoomScale;
    CGFloat scale = MIN(self.scrollView.frame.size.width / self.width, self.scrollView.frame.size.height / self.height);

    for (NSString *str in self.coordsArr) {
        NSArray *pointArr = [str componentsSeparatedByString:@","];
    
        point.x = scale * [pointArr[0] intValue];
        point.y = scale * [pointArr[1] intValue];
        
        UIImageView *mark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_onmap"]];
        CGRect markFrame = mark.frame;
        markFrame.size.width *= scale;
        markFrame.size.height *= scale;
        mark.frame = markFrame;
        
        mark.center = point;
        [self.imageView addSubview:mark];
    }
    
}

// 楼层按钮
- (void)setUpFloors_Buttons {

    for (ShopGuideButton *button in self.floorButtons) {
        [button removeFromSuperview];
    }
    [self.floorButtons removeAllObjects];
    if (self.floorScrollView) {
        self.floorScrollView.frame = CGRectZero;
    }
    
    NSInteger count = self.floorsArr.count;
    if (count == 0) {
        return;
    }
    
    CGFloat x = 0;
    CGFloat y = self.view.frame.size.height - (_isShow?kButtomViewH:0) - kButtonTopH;
    CGFloat w = self.view.frame.size.width;
    CGFloat h = kButtomViewH + kButtonTopH;
    
    CGRect buttomView = CGRectMake(x, y, w, h);
    
    CGRect scrollFrame = CGRectMake(0, kButtonTopH, w, kButtomViewH - 40);
    CGSize contentSize = CGSizeMake(w, (count/2 + 1) * (kButtomSizeH));

    if (!self.buttomView) {
        self.buttomView = [[UIView alloc] initWithFrame:buttomView];
        self.buttomView.backgroundColor = [UIColor colorWithRed:54/255.0 green:51/255.0 blue:47/255.0 alpha:1];
        [self.view addSubview:self.buttomView];
        
        UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clickBtn setTitle:@"购物区域选择" forState:UIControlStateNormal];
        clickBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        clickBtn.frame = CGRectMake(0, 0, w, kButtonTopH);
        [self.buttomView addSubview:clickBtn];
        
        [clickBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }

    BOOL bounceVertical = NO;
    if (scrollFrame.size.height > kButtomViewH - 40) {
        scrollFrame.size.height = kButtomViewH - 40;
        bounceVertical = YES;
    }
    if (!self.floorScrollView) {
        self.floorScrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        self.floorScrollView.alwaysBounceHorizontal = NO;
        [self.buttomView addSubview:self.floorScrollView];
    }
    
    self.floorScrollView.backgroundColor = [UIColor clearColor];
    
    self.floorScrollView.frame = scrollFrame;
    self.floorScrollView.contentSize = contentSize;
    self.floorScrollView.showsVerticalScrollIndicator = NO;
    self.floorScrollView.showsHorizontalScrollIndicator = NO;
    self.floorScrollView.alwaysBounceVertical = bounceVertical;
    
    CGFloat btnPadding = kButtomPadding;
    CGFloat buttonX = btnPadding, buttonY = btnPadding;
    CGFloat buttonW = (w - btnPadding * 3)/2, buttonH = kButtomSizeH;
    
    for (int i = 0; i<self.floorsArr.count; i++) {
        
        NSString *floorNumber = self.floorsArr[i];
        
        buttonX = (buttonW + btnPadding) * (i%2) + btnPadding;
        buttonY = (buttonH  + btnPadding) * (i/2);
        
        ShopGuideButton *button = [[ShopGuideButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
        button.tag = i + kFloorTag;
        [button addTarget:self action:@selector(onFloorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%@", floorNumber] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [self.floorScrollView addSubview:button];
        [self.floorButtons addObject:button];
    }
    
    self.floorScrollView.contentSize = CGSizeMake(w, buttonY + buttonH + btnPadding);

}

- (void)clickBtn:(id)sender
{
    CGRect frame = self.buttomView.frame;
    
    if (_isShow) {
        _isShow = NO;
        frame.origin.y = self.view.frame.size.height - kButtonTopH;
    }else{
        _isShow = YES;
        frame.origin.y = self.view.frame.size.height - kButtomViewH;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.buttomView.frame = frame;
    }];
}

- (void)setUpFloors_Buttons_NoView
{
    for (ShopGuideButton *button in self.floorButtons) {
        [button removeFromSuperview];
    }
    [self.floorButtons removeAllObjects];
    if (self.floorScrollView) {
        self.floorScrollView.frame = CGRectZero;
    }
    
    NSInteger count = self.floorsArr.count;
    if (count == 0) {
        return;
    }
    
    CGFloat x = self.view.frame.size.width - kButtonSize - kButtonRightSpacing;
    CGFloat y = kButtonTopSpacing;
    CGFloat w = kButtonSize;
    CGFloat h = kButtonSize * count + kButtonItemSpacing * (count - 1);
    CGSize contentSize = CGSizeMake(w, h);
    CGRect scrollFrame = CGRectMake(x, y, w, h);
    BOOL bounceVertical = NO;
    if (scrollFrame.size.height > self.view.frame.size.height - 2 * kButtonTopSpacing) {
        scrollFrame.size.height = self.view.frame.size.height - 2 * kButtonTopSpacing;
        bounceVertical = YES;
    }
    if (!self.floorScrollView) {
        self.floorScrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        self.floorScrollView.alwaysBounceHorizontal = NO;
        [self.view addSubview:self.floorScrollView];
    }
    
    self.floorScrollView.backgroundColor = [UIColor redColor];
    
    self.floorScrollView.frame = scrollFrame;
    self.floorScrollView.contentSize = contentSize;
    self.floorScrollView.showsVerticalScrollIndicator = NO;
    self.floorScrollView.showsHorizontalScrollIndicator = NO;
    self.floorScrollView.alwaysBounceVertical = bounceVertical;
    
    CGFloat buttonX = 0, buttonY = 0;
    
    for (int i = 0; i<self.floorsArr.count; i++) {
        
        NSNumber *floorNumber = self.floorsArr[i];
        
        ShopGuideButton *button = [[ShopGuideButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, kButtonSize, kButtonSize)];
        button.tag = i + kFloorTag;
        [button addTarget:self action:@selector(onFloorButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%@", floorNumber] forState:UIControlStateNormal];
        
        //        if (floor == [self.locate.floor integerValue]) {
        //            button.on = YES;
        //        }
        
        [self.floorScrollView addSubview:button];
        [self.floorButtons addObject:button];
        buttonY += kButtonItemSpacing + kButtonSize;
    }
}

- (void)setUpService_Buttons {
    
    for (ShopGuideServiceButton *button in self.serviceButtons) {
        [button removeFromSuperview];
    }
    [self.serviceButtons removeAllObjects];
    if (self.serviceScrollView) {
        self.serviceScrollView.frame  = CGRectZero;
    }
    
    NSInteger count = self.serviceArr.count;
    if (count == 0) {
        return;
    }
    
    CGFloat x = kButtonLeftSpacing;
    CGFloat y = kButtonTopSpacing;
    CGFloat w = kButtonSize;
    CGFloat h = kButtonSize * count + kButtonItemSpacing * (count - 1);
    CGSize contentSize = CGSizeMake(w, h);
    CGRect scrollFrame = CGRectMake(x, y, w, h);
    BOOL bounceVertical = NO;
    if (scrollFrame.size.height > self.view.frame.size.height - 2 * kButtonTopSpacing) {
        scrollFrame.size.height = self.view.frame.size.height - 2 * kButtonTopSpacing;
        bounceVertical = YES;
    }
    if (!self.serviceScrollView) {
        self.serviceScrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        self.serviceScrollView.alwaysBounceHorizontal = NO;
        [self.view addSubview:self.serviceScrollView];
    }
    
    
    self.serviceScrollView.frame = scrollFrame;
    self.serviceScrollView.contentSize = contentSize;
    self.serviceScrollView.showsVerticalScrollIndicator = NO;
    self.serviceScrollView.showsHorizontalScrollIndicator = NO;
    self.serviceScrollView.alwaysBounceVertical = bounceVertical;
    
    CGFloat buttonX = 0, buttonY = 0;
    for (int i =0 ; i< self.serviceArr.count ; i++) {
        
        NSNumber *serviceType = self.serviceArr[i];
        
        ShopGuideServiceType type = [serviceType integerValue];
        ShopGuideServiceButton *button = [[ShopGuideServiceButton alloc] initWithServiceType:type];
        button.tag = i+1;
        [button setFrame:CGRectMake(buttonX, buttonY, kButtonSize, kButtonSize)];
        [button addTarget:self action:@selector(onServiceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = kButtonSize/2;
        [self.serviceScrollView addSubview:button];
        [self.serviceButtons addObject:button];
        buttonY += kButtonItemSpacing + kButtonSize;
    }
}

- (void)onServiceButtonPressed:(id)sender {
    //SSLog(@"onServiceButtonPressed: type = %@", @([sender tag]));
    if(_isShow)
        [self clickBtn:nil];
    [self resetOnOffStateForButton:(ShopGuideButton *)sender
                           inArray:self.serviceButtons];
    
    
}

- (void)onFloorButtonPressed:(id)sender {

    //[self resetOnOffStateForButton:(ShopGuideButton *)sender inArray:self.floorButtons];
    [self clickBtn:nil];
    UIButton *button = (UIButton *)sender;
    NSString *keyString = self.floorsArr[button.tag - kFloorTag];
    [self requestBrandByFloor:[self.floorsDic objectForKey:keyString]];
}

- (void)resetOnOffStateForButton:(ShopGuideButton *)guideButton inArray:(NSArray *)buttonsArray {
    for (ShopGuideButton *button in buttonsArray) {
        button.on = (button == guideButton);
    }
    
    // mark service
    if (![guideButton isKindOfClass:[ShopGuideServiceButton class]]) {
        return;
    }
    for (UIView *subview in [self.imageView subviews]) {
        if ([subview isKindOfClass:[ServiceMarkImageView class]]) {
            [subview removeFromSuperview];
        }
    }

    NSInteger index = guideButton.tag - 1;
    NSString *keyString = self.serviceArr[index];
    [self markService:[keyString integerValue] PointArr:[self.serviceDic objectForKey:keyString]];
}
// 服务坐标
- (void)markService:(ShopGuideServiceType)serviceType PointArr:(NSArray *)pointArr {

    
    CGFloat width = self.width;
    CGFloat height = self.height;
    CGFloat scale = self.minimumZoomScale * self.scrollView.zoomScale;

    scale = MIN(self.scrollView.frame.size.width / width, self.scrollView.frame.size.height / height);
    
    for (NSString *pointString in pointArr) {
        
        CGPoint point;
        NSArray *thePoint = [pointString componentsSeparatedByString:@","];
    
        point.x = [thePoint[0] intValue];
        point.y = [thePoint[1] intValue];

        point.x *= scale;
        point.y *= scale;
        
        ServiceMarkImageView *mark = [[ServiceMarkImageView alloc] initWithImage:ServiceMarkImage(serviceType)];
        CGRect markFrame = mark.frame;
        markFrame.size.width *= scale;
        markFrame.size.height *= scale;
        mark.frame = markFrame;
        
        mark.center = point;
        [self.imageView addSubview:mark];
    }
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

#pragma mark -
#pragma mark TapDetectingImageViewDelegate methods

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotSingleTapAtPoint:(CGPoint)tapPoint {
    // single tap does nothing for now
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotDoubleTapAtPoint:(CGPoint)tapPoint {
    // double tap zooms in
    float newScale = [self.scrollView zoomScale] * ZOOM_STEP;
    newScale = MIN(newScale, self.scrollView.maximumZoomScale);
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [self.scrollView zoomToRect:zoomRect animated:YES];
}

- (void)tapDetectingImageView:(TapDetectingImageView *)view gotTwoFingerTapAtPoint:(CGPoint)tapPoint {
    // two-finger tap zooms out
    if (flessthan([self.scrollView zoomScale], [self.scrollView minimumZoomScale])) {
        return;
    }
    float newScale = [self.scrollView zoomScale] / ZOOM_STEP;
    newScale = MAX(newScale, self.scrollView.minimumZoomScale);
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:tapPoint];
    [self.scrollView zoomToRect:zoomRect animated:YES];
}


#pragma mark -
#pragma mark Utility methods

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates.
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [self.scrollView frame].size.height / scale;
    zoomRect.size.width  = [self.scrollView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}


@end
