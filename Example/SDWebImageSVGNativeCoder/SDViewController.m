//
//  SDViewController.m
//  SDWebImageSVGNativeCoder
//
//  Created by dreampiggy on 08/01/2022.
//  Copyright (c) 2022 dreampiggy. All rights reserved.
//

#import "SDViewController.h"
#import <SDWebImageSVGNativeCoder/SDImageSVGNativeCoder.h>

@interface SDViewController ()

@end

@implementation SDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    SDImageSVGNativeCoder *SVGNativeCoder = [SDImageSVGNativeCoder sharedCoder];
    [[SDImageCodersManager sharedManager] addCoder:SVGNativeCoder];
    NSURL *svgURL = [NSURL URLWithString:@"https://s3-symbol-logo.tradingview.com/adobe--big.svg"];
    NSURL *svgURL2 = [NSURL URLWithString:@"https://s3-symbol-logo.tradingview.com/apple--big.svg"];
    
    CGSize screenSize = self.view.bounds.size;
    
    UIImageView *imageView1 = [[UIImageView alloc] init];
    imageView1.frame = CGRectMake(0, 0, screenSize.width, screenSize.height / 2);
    imageView1.contentMode = UIViewContentModeScaleAspectFit;
    imageView1.clipsToBounds = YES;
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.frame = CGRectMake(0, screenSize.height / 2, screenSize.width, screenSize.height / 2);
    imageView2.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.view addSubview:imageView1];
    [self.view addSubview:imageView2];
    
    [imageView1 sd_setImageWithURL:svgURL placeholderImage:nil options:SDWebImageRetryFailed context:@{SDWebImageContextImageThumbnailPixelSize: @(CGSizeMake(1000, 1000))} progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSLog(@"SVG1 load success");
        }
    }];
    [imageView2 sd_setImageWithURL:svgURL2 placeholderImage:nil options:SDWebImageRetryFailed context:@{SDWebImageContextImageThumbnailPixelSize: @(CGSizeMake(1000, 1000))} progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            NSLog(@"SVG2 load success");
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
