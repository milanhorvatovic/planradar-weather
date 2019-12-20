//
//  City+CoreDataProperties.m
//  
//
//  Created by worker on 19/12/2019.
//
//

#import "City+CoreDataProperties.h"

@implementation City (CoreDataProperties)

+ (NSFetchRequest<City *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"City"];
}

@dynamic countryCode;
@dynamic identifier;
@dynamic name;
@dynamic weathers;

@end
