//
//  City+CoreDataProperties.h
//  
//
//  Created by worker on 19/12/2019.
//
//

#import "City+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface City (CoreDataProperties)

+ (NSFetchRequest<City *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *countryCode;
@property (nullable, nonatomic, copy) NSNumber *identifier;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<WeatherInfo *> *weathers;

@end

@interface City (CoreDataGeneratedAccessors)

- (void)addWeathersObject:(WeatherInfo *)value;
- (void)removeWeathersObject:(WeatherInfo *)value;
- (void)addWeathers:(NSSet<WeatherInfo *> *)values;
- (void)removeWeathers:(NSSet<WeatherInfo *> *)values;

@end

NS_ASSUME_NONNULL_END
