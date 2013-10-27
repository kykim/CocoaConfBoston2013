//
//  BeaconCat+Image.m
//  BeaconClient
//
//  Created by Kevin Y. Kim on 10/23/13.
//  Copyright (c) 2013 AppOrchard, LLC. All rights reserved.
//

#import "BeaconCat+Image.h"

@implementation BeaconCat (Image)

- (UIImage *)image
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:self.id ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}


@end
