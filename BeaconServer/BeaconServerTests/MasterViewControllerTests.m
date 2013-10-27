//
//  MasterViewControllerTests.m
//  BeaconServer
//
//  Created by Kevin Y. Kim on 10/22/13.
//  Copyright (c) 2013 AppOrchard, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MasterViewController.h"
#import "Cat.h"

@interface MasterViewControllerTests : XCTestCase
@property (nonatomic, strong) MasterViewController *target;
@end

@implementation MasterViewControllerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    self.target = [[MasterViewController alloc] init];
}

- (void)tearDown
{
    self.target = nil;
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testConfigureCellForIndexPathSetsCellText
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TestCell"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    NSString *expected = @"Expected Text";
    Cat *cat = [[Cat alloc] initWithDictionary:@{ @"id" : expected }];
    self.target.cats = @[ cat ];
    
    [self.target configureCell:cell forIndexPath:indexPath];
    
    XCTAssertEqualObjects(cell.textLabel.text, expected, @"Expected Cell TextLabel Text to be %@", expected);
}

@end
