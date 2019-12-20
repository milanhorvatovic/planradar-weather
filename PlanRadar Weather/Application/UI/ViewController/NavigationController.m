//
//  NavigationController.m
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.titleTextAttributes = @{
        NSForegroundColorAttributeName: [UIColor colorNamed:@"NormalText"],
        NSFontAttributeName: [UIFont systemFontOfSize:15
                                               weight:UIFontWeightBold]
    };
}

@end
