//
//  DataProvider.m
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "DataProvider.h"

#import "ModelServiceWeather.h"
#import "City+CoreDataClass.h"
#import "City+CoreDataProperties.h"
#import "WeatherInfo+CoreDataClass.h"
#import "WeatherInfo+CoreDataProperties.h"

@implementation NSPersistentContainer (NetworkEngine)

- (nonnull NSManagedObjectContext *)retrieveReadContext {
    return self.viewContext;
}

- (nonnull NSManagedObjectContext *)createWriteContext {
    NSManagedObjectContext *context = [self newBackgroundContext];
    context.automaticallyMergesChangesFromParent = YES;
    return context;
}

@end

@interface DataProvider ()

@property (nonnull, readwrite, strong, nonatomic) id<StoreEngine> engine;

@end

@interface DataProvider (Private)

- (City *)_fetchCityForWeather:(ModelServiceWeather *)weather
                   fromContext:(NSManagedObjectContext *)context
                         error:(NSError **)error;

- (City *)_insertCityFromWeather:(ModelServiceWeather *)weather
                       inContext:(NSManagedObjectContext *)context;

- (WeatherInfo *)_insertWeather:(ModelServiceWeather *)weather
                        forCity:(City *)city
                      inContext:(NSManagedObjectContext *)context;

@end

@implementation DataProvider

- (instancetype)initWithEngine:(id<StoreEngine>)engine {
    if (self = [super init]) {
        self.engine = engine;
    }
    return self;
}

@end

@implementation DataProvider (Fetch)

- (nonnull NSFetchedResultsController *)fetchCities {
    if (!NSThread.isMainThread) {
        @throw [NSException exceptionWithName:@"Invalid processing"
                                       reason:@"Fetching cities has to be executed on main thread."
                                     userInfo:nil];
    }
    NSFetchRequest *fetchRequest = [City fetchRequest];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                   ascending:YES]];
    [NSFetchedResultsController deleteCacheWithName:@"CitiesListCacheName"];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:self.engine.retrieveReadContext
                                                 sectionNameKeyPath:nil
                                                          cacheName:@"CitiesListCacheName"];
}

- (nonnull NSFetchedResultsController *)fetchWeatherInfosForCity:(City *)city {
    if (!NSThread.isMainThread) {
        @throw [NSException exceptionWithName:@"Invalid processing"
                                       reason:@"Fetching weather infos has to be executed on main thread."
                                     userInfo:nil];
    }
    NSFetchRequest *fetchRequest = [WeatherInfo fetchRequest];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"city.identifier == %@", city.identifier];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date"
                                                                   ascending:NO]];
    [NSFetchedResultsController deleteCacheWithName:@"WeatherInfosListCacheName"];
    return [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                               managedObjectContext:self.engine.retrieveReadContext
                                                 sectionNameKeyPath:nil
                                                          cacheName:@"WeatherInfosListCacheName"];
}

@end

@implementation DataProvider (Save)

- (void)saveWeather:(ModelServiceWeather *)weather {
    if (NSThread.isMainThread) {
        @throw [NSException exceptionWithName:@"Invalid processing"
                                       reason:@"Saving weather has to be executed on another than main thread."
                                     userInfo:nil];
    }
    NSError *error;
    NSManagedObjectContext *context = [self.engine createWriteContext];
    City *city = [self _fetchCityForWeather:weather
                                fromContext:context
                                      error:&error];
    if (!city) {
        city = [self _insertCityFromWeather:weather
                                  inContext:context];
        if (!city) {
            @throw [NSException exceptionWithName:@"Invalid processing"
                                           reason:[NSString stringWithFormat:@"Saving city failed due to %@", error]
                                         userInfo:nil];
        }
    }
    [self _insertWeather:weather
                 forCity:city
               inContext:context];
    if (![context save:&error]) {
        @throw [NSException exceptionWithName:@"Invalid processing"
                                       reason:[NSString stringWithFormat:@"Saving context failed due to %@", error]
                                     userInfo:nil];
    }
}

@end

@implementation DataProvider (Private)

- (City *)_fetchCityForWeather:(ModelServiceWeather *)weather
                   fromContext:(NSManagedObjectContext *)context
                         error:(NSError **)error {
    NSFetchRequest *fetchRequest = [City fetchRequest];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name == %@", weather.cityName];
    return [context executeFetchRequest:fetchRequest
                                  error:error].firstObject;
}

- (City *)_insertCityFromWeather:(ModelServiceWeather *)weather
                       inContext:(NSManagedObjectContext *)context {
    NSEntityDescription *descriptor = [NSEntityDescription entityForName:NSStringFromClass(City.self)
                                                  inManagedObjectContext:context];
    City *entity = [[City alloc] initWithEntity:descriptor
                 insertIntoManagedObjectContext:context];
    entity.identifier = weather.identifier;
    entity.name = weather.cityName;
    entity.countryCode = weather.countryCode;
    return entity;
}

- (WeatherInfo *)_insertWeather:(ModelServiceWeather *)weather
                        forCity:(City *)city
                      inContext:(NSManagedObjectContext *)context {
    NSEntityDescription *descriptor = [NSEntityDescription entityForName:[WeatherInfo fetchRequest].entityName
                                                  inManagedObjectContext:context];
    WeatherInfo *entity = [[WeatherInfo alloc] initWithEntity:descriptor
                               insertIntoManagedObjectContext:context];
    entity.date = weather.date;
    entity.state = weather.state;
    entity.temperature = weather.temperature;
    entity.humidity = weather.humidity;
    entity.windSpeed = weather.windSpeed;
    entity.city = city;
    [city addWeathersObject:entity];
    return entity;
}

@end
