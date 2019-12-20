//
//  NSObject+CityDetailViewController_Protected.h
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "CityDetailViewController.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

#import "FormatterHelper.h"

FOUNDATION_EXPORT NSString * _Nonnull const DetailIconURLTemplate;

@interface CityDetailViewController ()

@property (nullable, readwrite, strong, nonatomic) UIButton *_closeButton;
@property (nullable, readwrite, strong, nonatomic) UILabel *_titleLabel;
@property (nullable, readwrite, strong, nonatomic) UIView *_contentView;
@property (nullable, readwrite, strong, nonatomic) UIStackView *_dataStackView;
@property (nullable, readwrite, strong, nonatomic) UIImageView *_iconImageView;
@property (nullable, readwrite, strong, nonatomic) UILabel *_stateLabel;
@property (nullable, readwrite, strong, nonatomic) UILabel *_temperatureLabel;
@property (nullable, readwrite, strong, nonatomic) UILabel *_humidityLabel;
@property (nullable, readwrite, strong, nonatomic) UILabel *_windSpeedLabel;

@property (nullable, readwrite, strong, nonatomic) UILabel *_footerLabel;

@end
