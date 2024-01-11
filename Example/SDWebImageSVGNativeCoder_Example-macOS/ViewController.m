//
//  ViewController.m
//  SDWebImageSVGNativeCoder_Example-macOS
//
//  Created by lizhuoli on 2024/1/11.
//  Copyright © 2024 dreampiggy. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImageSVGNativeCoder/SDImageSVGNativeCoder.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SDImageCache.sharedImageCache clearDiskOnCompletion:nil];

    SDImageSVGNativeCoder *SVGNativeCoder = [SDImageSVGNativeCoder sharedCoder];
    [[SDImageCodersManager sharedManager] addCoder:SVGNativeCoder];
    NSURL *svgURL = [NSURL URLWithString:@"https://s3-symbol-logo.tradingview.com/adobe--big.svg"];
    NSURL *svgURL2 = [NSURL URLWithString:@"https://s3-symbol-logo.tradingview.com/apple--big.svg"];
    
    CGSize screenSize = self.view.bounds.size;
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.frame = CGRectMake(0, 0, screenSize.width / 2, screenSize.height);
    imageView1.imageScaling = NSImageScaleProportionallyUpOrDown;
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.frame = CGRectMake(screenSize.width / 2, 0, screenSize.width / 2, screenSize.height);
    imageView2.imageScaling = NSImageScaleProportionallyUpOrDown;
    
    [self.view addSubview:imageView1];
    [self.view addSubview:imageView2];
    
    [imageView1 sd_setImageWithURL:svgURL placeholderImage:nil options:SDWebImageRetryFailed context:@{SDWebImageContextImageThumbnailPixelSize: @(CGSizeMake(1000, 1000))} progress:nil completed:^(NSImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSLog(@"SVG1 load success");
        }
    }];
    [imageView2 sd_setImageWithURL:svgURL2 placeholderImage:nil options:SDWebImageRetryFailed context:@{SDWebImageContextImageThumbnailPixelSize: @(CGSizeMake(1000, 1000))} progress:nil completed:^(NSImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSLog(@"SVG2 load success");
        }
    }];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
