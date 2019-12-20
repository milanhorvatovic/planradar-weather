//
//  CityDetailViewController.h
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "CommonViewController.h"

@class City;
@protocol WeatherDataLoader, SaveDataProvider;

NS_ASSUME_NONNULL_BEGIN

@interface CityDetailViewController: CommonViewController

- (instancetype)initWithCity:(City *)city
           weatherDataLoader:(id<WeatherDataLoader>)dataLoader
            saveDataProvider:(id<SaveDataProvider>)dataProvider;

@end

NS_ASSUME_NONNULL_END
