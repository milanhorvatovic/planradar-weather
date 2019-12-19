//
//  CitiesListCell.h
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

@import UIKit;

@class City;

NS_ASSUME_NONNULL_BEGIN

@interface CitiesListCell: UITableViewCell

@end

@interface CitiesListCell (Configure)

- (void)configureWithCity:(nonnull City *)city;

@end

NS_ASSUME_NONNULL_END
