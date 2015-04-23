//
//  ShopInfoMapViewController.m
//  Discount
//
//  Created by jackyzeng on 3/24/15.
//  Copyright (c) 2015 wanjiahui. All rights reserved.
//

#import "ShopInfoMapViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface ShopInfoMapViewController () <MAMapViewDelegate>

@property(nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

- (void)initMapView;

@end

@implementation ShopInfoMapViewController

- (instancetype)initWithCenterCoordinate:(CLLocationCoordinate2D)coordinate
                               zoomLevel:(CGFloat)zoomLevel {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _centerCoordinate  = coordinate;
        _zoomLevel = zoomLevel;
        if (flessthan(_zoomLevel, 0.0f)) {
            _zoomLevel = 6.0f; // default set to 6.0f
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBackItem];
    
    [self initMapView];
}

- (void)initMapView
{
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    self.mapView.centerCoordinate = self.centerCoordinate;
    
    [self.view addSubview:self.mapView];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)onCustomBackItemClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    self.mapView.showsUserLocation = YES;
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.mapView.delegate = nil;
}

#pragma mark - Life Cycle


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeNone;
    [self.mapView setZoomLevel:self.zoomLevel animated:YES];
    
    /* Add a annotation on map center. */
    [self addAnnotationWithCooordinate:self.mapView.centerCoordinate];
}

-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.title    = @"Annotation";
    annotation.subtitle = @"CustomAnnotationView";
    
    [self.mapView addAnnotation:annotation];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        
        annotationView.image = [UIImage imageNamed:@"common_onmap"];
        
        return annotationView;
    }
    
    return nil;
}

@end
