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

@interface CViewController () <MKMapViewDelegate>
@property (readwrite, nonatomic, strong) IBOutlet MKMapView *mapView;
@property (readwrite, nonatomic, strong) CSqliteDatabase *database;
@end

@implementation CViewController

@synthesize mapView;
@synthesize database;

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
        
        [self.mapView addOverlay:thePolygon];
        }
    
    }
    
- (void)didReceiveMemoryWarning
    {
    [super didReceiveMemoryWarning];
    NSLog(@"MEMORY WARNING");
    }
    
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
    {
    MKPolygonView *thePolygonView = [[MKPolygonView alloc] initWithPolygon:overlay];
    thePolygonView.strokeColor = [UIColor redColor];
    thePolygonView.lineWidth = 1.0;
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
