//
//  WeatherInfo+CoreDataProperties.m
//  
//
//  Created by worker on 19/12/2019.
//
//

#import "WeatherInfo+CoreDataProperties.h"

@implementation WeatherInfo (CoreDataProperties)

+ (NSFetchRequest<WeatherInfo *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"WeatherInfo"];
}

@dynamic date;
@dynamic humidity;
@dynamic state;
@dynamic temperature;
@dynamic windSpeed;
@dynamic city;

@end
