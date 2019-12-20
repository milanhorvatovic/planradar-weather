//
//  ModelServiceWeather.m
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "ModelServiceWeather.h"

@interface ModelServiceWeather () <MTLJSONSerializing>

@property (nonnull, readwrite, strong, nonatomic) NSNumber *identifier;
@property (nonnull, readwrite, copy, nonatomic) NSString *cityName;
@property (nonnull, readwrite, copy, nonatomic) NSString *countryCode;

@property (nonnull, readwrite, copy, nonatomic) NSString *state;
@property (nonnull, readwrite, strong, nonatomic) NSNumber *temperature;
@property (nonnull, readwrite, strong, nonatomic) NSNumber *humidity;
@property (nonnull, readwrite, strong, nonatomic) NSNumber *windSpeed;

@property (nonnull, readwrite, copy, nonatomic) NSString *icon;

@property (nonnull, readwrite, strong, nonatomic) NSDate *date;

@end

@implementation ModelServiceWeather

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"identifier": @"id",
        @"cityName": @"name",
        @"countryCode": @"sys.country",
        @"state": @"weather",
        @"temperature": @"main.temp",
        @"humidity": @"main.humidity",
        @"windSpeed": @"wind.speed",
        @"icon": @"weather",
        @"date": @"dt"
    };
}

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSDate dateWithTimeIntervalSince1970:value.doubleValue];
    }
                                                reverseBlock:^id(NSDate *value, BOOL *success, NSError *__autoreleasing *error) {
        return [NSNumber numberWithDouble:value.timeIntervalSince1970];
    }];
}

+ (NSValueTransformer *)stateJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray<NSDictionary *> *value, BOOL *success, NSError *__autoreleasing *error) {
        if (!value) {
            return nil;
        }
        NSDictionary *dictionary = value.firstObject;
        if (!dictionary) {
            return nil;
        }
        return dictionary[@"description"];
    }
                                                reverseBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        return nil;
    }];
}

+ (NSValueTransformer *)iconJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray<NSDictionary *> *value, BOOL *success, NSError *__autoreleasing *error) {
        if (!value) {
            return nil;
        }
        NSDictionary *dictionary = value.firstObject;
        if (!dictionary) {
            return nil;
        }
        return dictionary[@"icon"];
    }
                                                reverseBlock:^id(NSString *value, BOOL *success, NSError *__autoreleasing *error) {
        return nil;
    }];
}

@end
