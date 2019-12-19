//
//  WeatherInfo+CoreDataProperties.h
//  
//
//  Created by worker on 19/12/2019.
//
//

#import "WeatherInfo+CoreDataClass.h"

@class City;

NS_ASSUME_NONNULL_BEGIN

@interface WeatherInfo (CoreDataProperties)

+ (NSFetchRequest<WeatherInfo *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSNumber *humidity;
@property (nullable, nonatomic, copy) NSString *state;
@property (nullable, nonatomic, copy) NSNumber *temperature;
@property (nullable, nonatomic, copy) NSNumber *windSpeed;
@property (nullable, nonatomic, retain) City *city;

@end

NS_ASSUME_NONNULL_END
