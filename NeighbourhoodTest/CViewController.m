//
//  CViewController.m
//  NeighbourhoodTest
//
//  Created by Jonathan Wight on 12/20/11.
//  Copyright (c) 2011 toxicsoftware.com. All rights reserved.
//

#import "CViewController.h"

#import <MapKit/MapKit.h>

#import "TouchSQL.h"

#import <objc/runtime.h>

static void *kKey;

@interface CViewController () <MKMapViewDelegate>
@property (readwrite, nonatomic, strong) IBOutlet MKMapView *mapView;
@property (readwrite, nonatomic, strong) CSqliteDatabase *database;
@property (readwrite, nonatomic, strong) NSCache *overlayViewCache;
@end

@implementation CViewController

@synthesize mapView;
@synthesize database;
@synthesize overlayViewCache;

- (void)viewDidLoad
    {
    [super viewDidLoad];
    
    NSURL *theURL = [[NSBundle mainBundle] URLForResource:@"shapes" withExtension:@"sqlite"];

    NSError *theError = NULL;
    self.database = [[CSqliteDatabase alloc] initWithURL:theURL flags:SQLITE_OPEN_READONLY error:&theError];
    
    CSqliteStatement *theStatement = [self.database statementWithFormat:@"SELECT * FROM neighbourhood"];
    for (NSDictionary *theRecord in theStatement)
        {
//        NSLog(@"%@", foo);
        
        NSData *thePointsData = [theRecord objectForKey:@"points"];
        const CLLocationCoordinate2D *theCoordinates = [thePointsData bytes];
        NSUInteger theCount = thePointsData.length / sizeof(CLLocationCoordinate2D);
        
        MKPolygon *thePolygon = [MKPolygon polygonWithCoordinates:theCoordinates count:theCount];
        objc_setAssociatedObject(thePolygon, &kKey, [theRecord objectForKey:@"id"], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self.mapView addOverlay:thePolygon];
        }
    
    
    overlayViewCache = [[NSCache alloc] init];
    }
    
- (void)didReceiveMemoryWarning
    {
    [super didReceiveMemoryWarning];
    NSLog(@"MEMORY WARNING");
    }
    
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
    {
    id theKey = objc_getAssociatedObject(overlay, &kKey);
    MKPolygonView *thePolygonView = [self.overlayViewCache objectForKey:theKey];
    if (thePolygonView == NULL)
        {
        thePolygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
        thePolygonView.strokeColor = [UIColor redColor];
        thePolygonView.lineWidth = 1.0;
        [self.overlayViewCache setObject:thePolygonView forKey:theKey];
        }
    return(thePolygonView);
    }

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
