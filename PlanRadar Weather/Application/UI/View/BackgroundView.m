//
//  BackgroundView.m
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "BackgroundView.h"

@interface BackgroundView ()

@property (nullable, readwrite, weak, nonatomic) CALayer *gradientLayer;

@end

@implementation BackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = @[(id)[UIColor colorNamed:@"BackgroundGradientFrom"].CGColor,
                            (id)[UIColor colorNamed:@"BackgroundGradientTo"].CGColor];
        [self.layer insertSublayer:gradient atIndex:0];
        self.gradientLayer = gradient;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.gradientLayer.frame, self.bounds)) {
        self.gradientLayer.frame = self.bounds;
    }
}

@end
