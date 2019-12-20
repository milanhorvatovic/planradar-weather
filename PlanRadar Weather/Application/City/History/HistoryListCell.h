//
//  HistoryListCell.h
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

@import UIKit;

@class WeatherInfo;

NS_ASSUME_NONNULL_BEGIN

@interface HistoryListCell: UITableViewCell

@end

@interface HistoryListCell (Configure)

- (void)configureWithWeatherInfo:(nonnull WeatherInfo *)weatherInfo;

@end

NS_ASSUME_NONNULL_END
