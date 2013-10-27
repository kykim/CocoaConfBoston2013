//
//  DetailViewController.m
//  BeaconServer
//
//  Created by Kevin Y. Kim on 10/22/13.
//  Copyright (c) 2013 AppOrchard, LLC. All rights reserved.
//

#import "DetailViewController.h"
#import "PeripheralManager.h"

@interface DetailViewController () <CBPeripheralManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *major;
@property (weak, nonatomic) IBOutlet UILabel *minor;
@property (weak, nonatomic) IBOutlet UIImageView *advertisingImage;
@property (weak, nonatomic) IBOutlet UIButton *advertisingButton;
- (void)configureView;
- (IBAction)advertise:(id)sender;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setCat:(BeaconCat *)newCat
{
    if (_cat != newCat) {
        _cat = newCat;
        
        // Update the view.
        [self configureView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    [[PeripheralManager sharedInstance] setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self startAdvertising];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAdvertising];
}

#pragma mark - Instance Methods

- (void)startAdvertising
{
    NSDictionary *peripheralData = nil;
    CLBeaconRegion *region = self.cat.beaconRegion;
    peripheralData = [region peripheralDataWithMeasuredPower:nil];
    
    // The region's peripheral data contains the CoreBluetooth-specific data we need to advertise.
    if (peripheralData) {
        [[PeripheralManager sharedInstance] startAdvertising:peripheralData];
    }
}

- (void)stopAdvertising
{
    [[PeripheralManager sharedInstance] stopAdvertising];
    self.advertisingImage.hidden = YES;
    [self.advertisingButton setTitle:@"Start Advertising" forState:UIControlStateNormal];
}

#pragma mark - Private Instance Methods

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.cat) {
        self.name.text = self.cat.name;
        self.major.text = self.cat.major.stringValue;
        self.minor.text = self.cat.minor.stringValue;
    }
}

- (IBAction)advertise:(id)sender
{
    if ([[PeripheralManager sharedInstance] isAdvertising]) {
        [self stopAdvertising];
    }
    else {
        [self startAdvertising];
    }
}

#pragma mark - CBPeripheralManager Delegate Methods

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    switch (peripheral.state) {
        case CBPeripheralManagerStateUnknown:
            break;
        case CBPeripheralManagerStateResetting:
            break;
        case CBPeripheralManagerStateUnsupported:
            break;
        case CBPeripheralManagerStateUnauthorized:
            break;
        case CBPeripheralManagerStatePoweredOff:
            break;
        case CBPeripheralManagerStatePoweredOn:
            break;
    }
}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error
{
    self.advertisingImage.hidden = NO;
    [self.advertisingButton setTitle:@"Stop Advertising" forState:UIControlStateNormal];
}

@end
