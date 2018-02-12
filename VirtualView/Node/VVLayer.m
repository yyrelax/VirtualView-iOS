//
//  VVLayer.m
//  VirtualView
//
//  Copyright (c) 2017-2018 Alibaba. All rights reserved.
//

#import "VVLayer.h"
#import <QuartzCore/QuartzCore.h>

@interface VVLayer () {
    CGFloat width;
    CGFloat height;
}

@property (nonatomic, assign, readonly) CGSize vv_size;

@end

@implementation VVLayer

@dynamic vv_size;

- (instancetype)init
{
    if (self = [super init]) {
        VVSetNeedsDisplayObserve(vv_size);
        VVSetNeedsDisplayObserve(vv_borderWidth);
        VVSetNeedsDisplayObserve(vv_borderColor);
        VVSetNeedsDisplayObserve(vv_borderRadius);
        VVSetNeedsDisplayObserve(vv_borderTopLeftRadius);
        VVSetNeedsDisplayObserve(vv_borderBottomLeftRadius);
        VVSetNeedsDisplayObserve(vv_borderTopRightRadius);
        VVSetNeedsDisplayObserve(vv_borderBottomRightRadius);
        VVSetNeedsDisplayObserve(vv_backgroundColor);
    }
    return self;
}

- (void)setVv_borderWidth:(CGFloat)vv_borderWidth
{
    _vv_borderWidth = vv_borderWidth > 0 ? vv_borderWidth : 0;
}

- (void)setVv_borderTopLeftRadius:(CGFloat)vv_borderTopLeftRadius
{
    _vv_borderTopLeftRadius = vv_borderTopLeftRadius > 0 ? vv_borderTopLeftRadius : 0;
}

- (void)setVv_borderTopRightRadius:(CGFloat)vv_borderTopRightRadius
{
    _vv_borderTopRightRadius = vv_borderTopRightRadius > 0 ? vv_borderTopRightRadius : 0;
}

- (void)setVv_borderBottomLeftRadius:(CGFloat)vv_borderBottomLeftRadius
{
    _vv_borderBottomLeftRadius = vv_borderBottomLeftRadius > 0 ? vv_borderBottomLeftRadius : 0;
}

- (void)setVv_borderBottomRightRadius:(CGFloat)vv_borderBottomRightRadius
{
    _vv_borderBottomRightRadius = vv_borderBottomRightRadius > 0 ? vv_borderBottomRightRadius : 0;
}

- (void)setVv_borderRadius:(CGFloat)vv_borderRadius
{
    _vv_borderRadius = vv_borderRadius > 0 ? vv_borderRadius : 0;
}

- (void)setFrame:(CGRect)frame
{
    [self willChangeValueForKey:@"vv_size"];
    [super setFrame:frame];
    width = CGRectGetWidth(frame);
    height = CGRectGetHeight(frame);
    [self didChangeValueForKey:@"vv_size"];
}

- (CGSize)vv_size
{
    return CGSizeMake(width, height);
}

- (void)createPath:(CGContextRef)context borderWidth:(CGFloat)borderWidth
{
    // 1--2--3
    // |     |
    // 0     4
    // |     |
    // 7--6--5
    CGFloat halfBorderWidth = borderWidth / 2;
    CGFloat maximunRadius = MIN(width, height) / 2 - halfBorderWidth;
    CGFloat minX = halfBorderWidth, midX = width / 2, maxX = width - halfBorderWidth;
    CGFloat minY = halfBorderWidth, midY = height / 2, maxY = height - halfBorderWidth;
    // start from 0
    CGContextMoveToPoint(context, minX, midY);
    // add arc from 1 to 2
    CGFloat radius = self.vv_borderTopLeftRadius > 0 ? self.vv_borderTopLeftRadius : self.vv_borderRadius;
    if (radius > maximunRadius) radius = maximunRadius;
    CGContextAddArcToPoint(context, minX, minY, midX, minY, radius);
    // add arc from 3 to 4
    radius = self.vv_borderTopRightRadius > 0 ? self.vv_borderTopRightRadius : self.vv_borderRadius;
    if (radius > maximunRadius) radius = maximunRadius;
    CGContextAddArcToPoint(context, maxX, minY, maxX, midY, radius);
    // add arc from 5 to 6
    radius = self.vv_borderBottomRightRadius > 0 ? self.vv_borderBottomRightRadius : self.vv_borderRadius;
    if (radius > maximunRadius) radius = maximunRadius;
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
    // add arc from 7 to 0
    radius = self.vv_borderBottomLeftRadius > 0 ? self.vv_borderBottomLeftRadius : self.vv_borderRadius;
    if (radius > maximunRadius) radius = maximunRadius;
    CGContextAddArcToPoint(context, minX, maxY, minX, midY, radius);
    // close the path
    CGContextClosePath(context);
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    
    if (self.vv_backgroundColor
        && [self.vv_backgroundColor isEqual:[UIColor clearColor]] == NO) {
        CGContextSetFillColorWithColor(context, self.vv_backgroundColor.CGColor);
        [self createPath:context borderWidth:self.vv_borderWidth];
        CGContextFillPath(context);
    }

    if (self.vv_borderWidth > 0
        && self.vv_borderColor
        && [self.vv_borderColor isEqual:[UIColor clearColor]] == NO) {
        CGContextSetLineWidth(context, self.vv_borderWidth);
        CGContextSetStrokeColorWithColor(context, self.vv_borderColor.CGColor);
        [self createPath:context borderWidth:self.vv_borderWidth];
        CGContextStrokePath(context);
    }
}

@end
