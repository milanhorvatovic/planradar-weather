//
//  NetworkEngine.m
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "NetworkEngine.h"

@interface Request ()

@property (nonnull, readwrite, strong, nonatomic) NSURL *url;

@end

@implementation Request

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Invalid initializer"
                                   reason:@"Use another way to allocate this class!"
                                 userInfo:nil];
}

- (instancetype)initWithURLComponents:(NSURLComponents *)urlComponents
                         relativePath:(NSString *)relativePath
                           queryItems:(NSArray<NSURLQueryItem *> *)queryItems {
    NSCharacterSet *slashSet = [NSCharacterSet characterSetWithCharactersInString:@"/"];
    
    NSString *path = [@[[urlComponents.path stringByTrimmingCharactersInSet:slashSet],
                        [relativePath stringByTrimmingCharactersInSet:slashSet]]
                      componentsJoinedByString:@"/"];
    urlComponents.path = [NSString stringWithFormat:@"/%@", path];
    urlComponents.queryItems = queryItems;
    NSURL *url = urlComponents.URL;
    if (!url) {
        @throw [NSException exceptionWithName:@"Init error"
                                       reason:@"Relative path is invalid"
                                     userInfo:nil];
    }
    if (self = [super init]) {
        self.url = url;
    }
    return self;
}

- (instancetype)initWithBasePath:(NSString *)base
                    relativePath:(NSString *)relativePath
                      queryItems:(NSArray<NSURLQueryItem *> *)queryItems {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithString:base];
    if (!urlComponents) {
        @throw [NSException exceptionWithName:@"Init error"
                                       reason:@"Base path is invalid"
                                     userInfo:nil];
    }
    return [self initWithURLComponents:urlComponents
                          relativePath:relativePath
                            queryItems:queryItems];
}

- (instancetype)initWithBaseURL:(NSURL *)base
                   relativePath:(NSString *)relativePath
                     queryItems:(NSArray<NSURLQueryItem *> *)queryItems {
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:base
                                                resolvingAgainstBaseURL:YES];
    if (!urlComponents) {
        @throw [NSException exceptionWithName:@"Init error"
                                       reason:@"Base URL is invalid"
                                     userInfo:nil];
    }
    return [self initWithURLComponents:urlComponents
                          relativePath:relativePath
                            queryItems:queryItems];
}

@end

@implementation AFURLSessionManager (NetworkEngine)

- (void)performRequest:(nonnull Request *)request
          completition:(nonnull NetworkEngineCompletition)completion {
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:request.url];
    NSURLSessionDataTask *task = [self dataTaskWithRequest:urlRequest
                                            uploadProgress:nil
                                          downloadProgress:nil
                                         completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
        }
        else {
            NSDictionary *data = (NSDictionary *)responseObject;
            if (!data) {
                @throw [NSException exceptionWithName:@"Invalid data type"
                                               reason:@"Response object has different data type"
                                             userInfo:nil];
            }
            completion(data, nil);
        }
    }];
    [task resume];
}

- (void)cancelAllRequests {
    [self.session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
        for (NSURLSessionTask *task in tasks) {
            [task cancel];
        }
    }];
}


@end
