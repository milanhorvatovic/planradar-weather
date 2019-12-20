//
//  ImageBackgroundView.m
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "ImageBackgroundView.h"

@implementation ImageBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background"]];
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        [self addSubview:imageView];
        [imageView.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
        [imageView.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
        [imageView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    }
    return self;
}

@end
