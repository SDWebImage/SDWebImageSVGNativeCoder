//
//  SDImageSVGNativeCoder.mm
//  SDWebImageSVGNativeCoder
//
//  Created by dreampiggy on 08/01/2022.
//  Copyright (c) 2022 dreampiggy. All rights reserved.
//

#import "SDImageSVGNativeCoder.h"
#import <Foundation/Foundation.h>
#import <svgnative/SVGDocument.h>
#if __has_include(<svgnative/ports/cg/CGSVGRenderer.h>)
#include <svgnative/ports/cg/CGSVGRenderer.h>
#else
#include <svgnative/CGSVGRenderer.h>
#endif

#define kSVGTagEnd @"</svg>"

@implementation SDImageSVGNativeCoder

+ (SDImageSVGNativeCoder *)sharedCoder {
    static dispatch_once_t onceToken;
    static SDImageSVGNativeCoder *coder;
    dispatch_once(&onceToken, ^{
        coder = [[SDImageSVGNativeCoder alloc] init];
    });
    return coder;
}

#pragma mark - Decode

- (BOOL)canDecodeFromData:(NSData *)data {
    return [self.class isSVGFormatForData:data];
}

- (nullable UIImage *)decodedImageWithData:(nullable NSData *)data options:(nullable SDImageCoderOptions *)options {
    if (!data) {
        return nil;
    }
    NSString *svgString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (!svgString) {
        return nil;
    }
    
    // Parse args
    CGSize imageSize = CGSizeZero;
    BOOL preserveAspectRatio = YES;
    if (options[SDImageCoderDecodeThumbnailPixelSize]) {
        NSValue *sizeValue = options[SDImageCoderDecodeThumbnailPixelSize];
#if SD_MAC
        imageSize = sizeValue.sizeValue;
#else
        imageSize = sizeValue.CGSizeValue;
#endif
    }
    if (options[SDImageCoderDecodePreserveAspectRatio]) {
        preserveAspectRatio = [options[SDImageCoderDecodePreserveAspectRatio] boolValue];
    }
    
    // From svg-native-viewer example/testCocoaCG, use C++ shared ptr
    // Create the renderer object
    auto renderer = std::make_shared<SVGNative::CGSVGRenderer>();

    // Create SVGDocument object and parse the passed SVG string.
    auto doc = SVGNative::SVGDocument::CreateSVGDocument([svgString UTF8String], renderer).release();
    if (!doc) {
        return nil;
    }
    
    CGSize svgSize = imageSize;
    if (CGSizeEqualToSize(svgSize, CGSizeZero)) {
        // If user don't provide view port size, use the view box size
        svgSize = CGSizeMake(doc->Width(), doc->Height());
    }
    
    // Draw on CGContext
    SDGraphicsBeginImageContext(svgSize);
    CGContextRef ctx = SDGraphicsGetCurrentContext();
    
    renderer->SetGraphicsContext(ctx);
    
#if SD_MAC
    // Core Graphics Coordinate System convert. SDWebImage use's non-flipped one
    // See: [NSGraphicsContext graphicsContextWithCGContext:context flipped:NO];
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -svgSize.height);
#endif
    
    doc->Render(svgSize.width, svgSize.height);
    
    renderer->ReleaseGraphicsContext();
    UIImage *image = SDGraphicsGetImageFromCurrentImageContext();
    SDGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Encode

// No support SVG Encode
- (BOOL)canEncodeToFormat:(SDImageFormat)format {
    return NO;
}

- (nullable NSData *)encodedDataWithImage:(nullable UIImage *)image format:(SDImageFormat)format options:(nullable SDImageCoderOptions *)options {
    return nil;
}

#pragma mark - Helper

+ (BOOL)isSVGFormatForData:(NSData *)data {
    if (!data) {
        return NO;
    }
    // Check end with SVG tag
    return [data rangeOfData:[kSVGTagEnd dataUsingEncoding:NSUTF8StringEncoding] options:NSDataSearchBackwards range: NSMakeRange(data.length - MIN(100, data.length), MIN(100, data.length))].location != NSNotFound;
}

@end
