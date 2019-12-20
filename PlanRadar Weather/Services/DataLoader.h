//
//  DataLoader.h
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NetworkEngine;
@class ModelServiceWeather;

NS_ASSUME_NONNULL_BEGIN

@protocol WeatherDataLoader

typedef void (^DataLoaderWeatherCompletition) (ModelServiceWeather * _Nullable object, NSError * _Nullable error);
typedef void (^DataLoaderWeathersCompletition) (NSArray<ModelServiceWeather *> * _Nullable object, NSError * _Nullable error);

- (void)loadWeatherWithName:(NSString *)name
               completition:(DataLoaderWeatherCompletition)completition;
- (void)loadWeathersWithIds:(NSArray<NSNumber *> *)ids
               completition:(DataLoaderWeathersCompletition)completition;

@end


@interface DataLoader : NSObject

- (instancetype)initWithBasePath:(NSString *)base
                          engine:(id<NetworkEngine>)engine;

@end

@interface DataLoader (Weather) <WeatherDataLoader>

@end

NS_ASSUME_NONNULL_END
