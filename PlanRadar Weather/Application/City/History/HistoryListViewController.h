//
//  HistoryListViewController.h
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//


@import UIKit;

#import "CommonViewController.h"
@class City;
@protocol FetchDataProvider;

NS_ASSUME_NONNULL_BEGIN

@interface HistoryListViewController: CommonViewController

- (instancetype)initWithCity:(City *)city
           fetchDataProvider:(id<FetchDataProvider>)dataProvider;

@end

NS_ASSUME_NONNULL_END
