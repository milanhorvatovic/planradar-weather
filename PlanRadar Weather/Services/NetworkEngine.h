//
//  NetworkEngine.h
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@import AFNetworking;

NS_ASSUME_NONNULL_BEGIN

@interface Request: NSObject

@property (nonnull, readonly, strong, nonatomic) NSURL *url;

- (instancetype)initWithBasePath:(NSString *)base
                    relativePath:(NSString *)relativePath
                      queryItems:(NSArray<NSURLQueryItem *> *)queryItems;

- (instancetype)initWithBaseURL:(NSURL *)base
                   relativePath:(NSString *)relativePath
                     queryItems:(NSArray<NSURLQueryItem *> *)queryItems;

@end

@protocol NetworkEngine

typedef void (^NetworkEngineCompletition) (NSDictionary * _Nullable json, NSError * _Nullable error);

- (void)performRequest:(Request *)request
          completition:(NetworkEngineCompletition)completion;

- (void)cancelAllRequests;

@end

@interface AFURLSessionManager (NetworkEngine) <NetworkEngine>

@end

NS_ASSUME_NONNULL_END
