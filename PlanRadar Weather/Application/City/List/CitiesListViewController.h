//
//  CitiesListViewController.h
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

@import UIKit;

#import "CommonViewController.h"
@protocol FetchDataProvider;

NS_ASSUME_NONNULL_BEGIN

@interface CitiesListViewController: CommonViewController

- (instancetype)initWithFetchDataProvider:(id<FetchDataProvider>)dataProvider;

@end

NS_ASSUME_NONNULL_END
