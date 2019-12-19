//
//  ApplicationFactory.m
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "ApplicationFactory.h"

#import "CitiesListViewController.h"

@implementation ApplicationFactory

+ (UIWindow *)createApplication {
    UIWindow *window = [[UIWindow alloc] initWithFrame: UIScreen.mainScreen.bounds];
    CitiesListViewController *viewController = [[CitiesListViewController alloc] init];
    window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [window makeKeyAndVisible];
    return window;
}

@end
