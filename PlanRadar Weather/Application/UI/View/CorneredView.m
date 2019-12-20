//
//  CorneredView.m
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "CorneredView.h"

@implementation CorneredView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.layer.cornerRadius == self.cornerRadius) {
        return;
    }
    self.layer.cornerRadius = self.cornerRadius;
}

@end
