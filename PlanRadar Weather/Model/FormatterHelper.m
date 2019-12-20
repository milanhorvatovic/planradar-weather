//
//  FormatterHelper.m
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "FormatterHelper.h"

@implementation FormatterHelper

+ (NSDateFormatter *)_relativeDateFormatter {
     static NSDateFormatter *dateFormatter;
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
         dateFormatter = [[NSDateFormatter alloc] init];
         NSLocale *locale = [NSLocale currentLocale];
         [dateFormatter setLocale:locale];
         [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
         [dateFormatter setDateStyle:NSDateFormatterNoStyle];
         [dateFormatter setDateFormat:@"dd.MM.yyyy - HH:mm"];
     });
     return dateFormatter;
}

@end

@implementation FormatterHelper (Date)

+ (NSString *)formatDate:(NSDate *)date {
    return [self._relativeDateFormatter stringFromDate:date];
}

@end

@implementation FormatterHelper (Temperature)

+ (NSString *)formatTemperature:(NSNumber *)value {
    return [NSString stringWithFormat:@"%ld°C", (NSInteger) round(value.doubleValue - 273.15)];
}

@end

@implementation FormatterHelper (Humidity)

+ (NSString *)formatHumidity:(NSNumber *)value {
    return [NSString stringWithFormat:@"%ld%%", (long) value.integerValue];
}

@end

@implementation FormatterHelper (WindSpeed)

+ (NSString *)formatWindSpeed:(NSNumber *)value {
    return [NSString stringWithFormat:@"%ld km/h", (NSInteger) round(value.doubleValue * 3.6)];
}

@end

