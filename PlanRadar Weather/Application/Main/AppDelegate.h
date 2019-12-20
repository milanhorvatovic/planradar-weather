//
//  AppDelegate.h
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol NetworkEngine;
@class DataLoader, DataProvider;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonnull, readonly, strong, nonatomic) id<NetworkEngine> networkEngine;
@property (nonnull, readonly, strong, nonatomic) DataLoader *dataLoader;
@property (nonnull, readonly, strong, nonatomic) DataProvider *dataProvider;

@property (nonnull, readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

