//
//  FormatterHelper.h
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface FormatterHelper: NSObject

@end

@interface FormatterHelper (Date)

+ (NSString *)formatDate:(NSDate *)date;

@end

@interface FormatterHelper (Temperature)

+ (NSString *)formatTemperature:(NSNumber *)value;

@end

@interface FormatterHelper (Humidity)

+ (NSString *)formatHumidity:(NSNumber *)value;

@end

@interface FormatterHelper (WindSpeed)

+ (NSString *)formatWindSpeed:(NSNumber *)value;

@end

NS_ASSUME_NONNULL_END
