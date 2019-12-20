//
//  ApplicationFactory.m
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "ApplicationFactory.h"

#import "AppDelegate.h"

#import "NavigationController.h"
#import "CitiesListViewController.h"

@implementation ApplicationFactory

+ (UIWindow *)createApplication {
    if (![UIApplication.sharedApplication.delegate isKindOfClass:[AppDelegate class]]) {
        @throw [NSException exceptionWithName:@"Initialization error"
                                       reason:@"UIApplication is not of AppDelegate type"
                                     userInfo:nil];
    }
    AppDelegate *appDelegate = (AppDelegate *) UIApplication.sharedApplication.delegate;
    if (!appDelegate) {
        @throw [NSException exceptionWithName:@"Initialization error"
                                       reason:@"AppDelegate is nil"
                                     userInfo:nil];
    }
    id<FetchDataProvider> dataProvider = (id<FetchDataProvider>) appDelegate.dataProvider;
    if (!dataProvider) {
        @throw [NSException exceptionWithName:@"Initialization error"
                                       reason:@"DataProvider is nil"
                                     userInfo:nil];
    }
    id<WeatherDataLoader> dataLoader = (id<WeatherDataLoader>) appDelegate.dataLoader;
    if (!dataProvider) {
        @throw [NSException exceptionWithName:@"Initialization error"
                                       reason:@"DataProvider is nil"
                                     userInfo:nil];
    }
    UIWindow *window = [[UIWindow alloc] initWithFrame: UIScreen.mainScreen.bounds];
    CitiesListViewController *viewController = [[CitiesListViewController alloc] initWithFetchDataProvider:dataProvider
                                                                                         weatherDataLoader:dataLoader];
    window.rootViewController = [[NavigationController alloc] initWithRootViewController:viewController];
    [window makeKeyAndVisible];
    window.tintColor = [UIColor colorNamed:@"Tint"];
    return window;
}

@end
