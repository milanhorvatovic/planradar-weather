//
//  DataLoader.m
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "DataLoader.h"

#import "NetworkEngine.h"
#import "ModelServiceWeather.h"
#import "ModelServiceWeatherList.h"

@import Mantle;

NSString *const _apiKeyConstant = @"d982cf2f779410e5a9e80342b414d39f";

@interface DataLoader ()

@property (nonnull, readwrite, strong, nonatomic) NSURL *url;
@property (nonnull, readwrite, strong, nonatomic) id<NetworkEngine> engine;

@end

@interface DataLoader (Private)

- (Request *)_constructRequestWithRelativePath:(NSString *)relativePath
                                    attributes:(NSDictionary *)queryAttributes;

@end

@interface DataLoader (PrivateLoad)

typedef void (^DataLoaderCompletition) (id _Nullable object, NSError * _Nullable error);

- (void)_loadWithRequest:(Request *)request
                   class:(Class)class
            completition:(DataLoaderCompletition)completition;

@end

@implementation DataLoader

- (instancetype)initWithBasePath:(NSString *)base
                          engine:(id<NetworkEngine>)engine {
    NSURL *url = [NSURL URLWithString:base];
    if (!url) {
        @throw [NSException exceptionWithName:@"Init error"
                                       reason:@"Base path is invalid"
                                     userInfo:nil];
    }
    if (self = [super init]) {
        self.url = url;
        self.engine = engine;
    }
    return self;
}

@end

@implementation DataLoader (Private)

- (Request *)_constructRequestWithRelativePath:(NSString *)relativePath
                                    attributes:(NSDictionary *)queryAttributes {
    NSMutableDictionary *attributes = [@{@"appid": _apiKeyConstant} mutableCopy];
    [attributes addEntriesFromDictionary:queryAttributes];
    NSMutableArray<NSURLQueryItem *> *queryItems = [[NSMutableArray alloc] init];
    for (NSString *key in attributes) {
        [queryItems addObject:[[NSURLQueryItem alloc] initWithName:key value:attributes[key]]];
    }
    return [[Request alloc] initWithBaseURL:self.url
                               relativePath:relativePath
                                 queryItems:queryItems];
}

@end

@implementation DataLoader (Weather)

- (void)loadWeatherWithName:(NSString *)name
               completition:(DataLoaderWeatherCompletition)completition {
    Request *request = [self _constructRequestWithRelativePath:@"/weather"
                                                    attributes:@{@"q": name}];
    [self _loadWithRequest:request
                     class:ModelServiceWeather.class
              completition:^(id  _Nullable object, NSError * _Nullable error) {
        if (error) {
            completition(nil, error);
            return;
        }
        completition(object, nil);
    }];
}

- (void)loadWeathersWithIds:(NSArray<NSNumber *> *)ids
               completition:(DataLoaderWeathersCompletition)completition {
    NSMutableArray<NSString *> *idsParameters = [[NSMutableArray alloc] init];
    for (NSNumber *id in ids) {
        [idsParameters addObject:[NSString stringWithFormat:@"%@", id]];
    }
    Request *request = [self _constructRequestWithRelativePath:@"/group"
                                                    attributes:@{@"id": [idsParameters componentsJoinedByString:@","]}];
    [self _loadWithRequest:request
                     class:ModelServiceWeatherList.class
              completition:^(id  _Nullable object, NSError * _Nullable error) {
        if (error) {
            completition(nil, error);
            return;
        }
        ModelServiceWeatherList *list = (ModelServiceWeatherList *) object;
        completition(list.list, nil);
    }];
}

@end

@implementation DataLoader (PrivateLoad)

- (void)_loadWithRequest:(Request *)request
                   class:(Class)class
            completition:(DataLoaderCompletition)completition {
    [self.engine performRequest:request
                   completition:^(NSDictionary * _Nullable json, NSError * _Nullable error) {
        if (error) {
            completition(nil, error);
            return;
        }
        id object = [MTLJSONAdapter modelOfClass:class
                              fromJSONDictionary:json
                                           error:&error];
        if (error) {
            completition(nil, error);
            return;
        }
        completition(object, nil);
    }];
}

@end
