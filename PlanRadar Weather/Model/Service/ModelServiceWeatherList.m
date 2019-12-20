//
//  ModelServiceWeatherList.m
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "ModelServiceWeatherList.h"

#import "ModelServiceWeather.h"

@interface ModelServiceWeatherList () <MTLJSONSerializing>

@property (nonnull, readwrite, strong, nonatomic) NSArray<ModelServiceWeather *> *list;

@end

@implementation ModelServiceWeatherList

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"list": @"list"
    };
}

+ (NSValueTransformer *)listJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:ModelServiceWeather.class];
}

@end
