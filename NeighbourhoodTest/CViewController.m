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
        
        NSString *thePointsString = [theRecord objectForKey:@"points"];
        NSData *thePointsData = [thePointsString dataUsingEncoding:NSASCIIStringEncoding];
        NSError *theError = NULL;
        NSArray *thePoints = [NSJSONSerialization JSONObjectWithData:thePointsData options:0 error:&theError];
        CLLocationCoordinate2D *theCoordinates = malloc(sizeof(CLLocationCoordinate2D) * thePoints.count);
        CLLocationCoordinate2D *P = theCoordinates;
        for (NSArray *thePointArray in thePoints)
            {
            *P++ = (CLLocationCoordinate2D){ 
                .latitude = [[thePointArray objectAtIndex:1] doubleValue],
                .longitude = [[thePointArray objectAtIndex:0] doubleValue],
                };
            }
        
        MKPolygon *thePolygon = [MKPolygon polygonWithCoordinates:theCoordinates count:thePoints.count];
        
        [self.mapView addOverlay:thePolygon];
        
        free(theCoordinates);
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
    [thePolygonView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
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

- (void)tap:(UITapGestureRecognizer *)inGestureRecognizer
    {
    NSLog(@"%@", inGestureRecognizer.view);
    }

@end
