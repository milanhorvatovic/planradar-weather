//
//  DataProvider.h
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

@import Foundation;

@import CoreData;

@class ModelServiceWeather;
@class City;

NS_ASSUME_NONNULL_BEGIN

@protocol StoreEngine

- (nonnull NSManagedObjectContext *)retrieveReadContext;
- (nonnull NSManagedObjectContext *)createWriteContext;

@end

@interface NSPersistentContainer (StoreEngine) <StoreEngine>

@end

@protocol FetchDataProvider

- (nonnull NSFetchedResultsController *)fetchCities;
- (nonnull NSFetchedResultsController *)fetchWeatherInfosForCity:(City *)city;

@end

@protocol SaveDataProvider

- (void)saveWeather:(ModelServiceWeather *)weather;

@end

@interface DataProvider: NSObject

@property (nonnull, readonly, strong, nonatomic) id<StoreEngine> engine;

- (instancetype)initWithEngine:(id<StoreEngine>)engine;

@end

@interface DataProvider (Fetch) <FetchDataProvider>

@end

@interface DataProvider (Save) <SaveDataProvider>

@end

NS_ASSUME_NONNULL_END
