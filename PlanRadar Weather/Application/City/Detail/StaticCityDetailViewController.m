//
//  StaticCityDetailViewController.m
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "StaticCityDetailViewController.h"
#import "CityDetailViewController_Protected.h"

#import "WeatherInfo+CoreDataProperties.h"
#import "City+CoreDataProperties.h"

@interface StaticCityDetailViewController (Configure)

- (void)_configureWithCity:(nonnull WeatherInfo *)weatherInfo;

@end

@interface StaticCityDetailViewController ()

@property (nonnull, readwrite, strong, nonatomic) WeatherInfo *weatherInfo;

@end

@implementation StaticCityDetailViewController

- (instancetype)initWithWeatherInfo:(WeatherInfo *)weatherInfo {
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        self.weatherInfo = weatherInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _configureWithCity:self.weatherInfo];
}

@end

@implementation StaticCityDetailViewController (Configure)

- (void)_configureWithCity:(nonnull WeatherInfo *)weatherInfo {
    self._titleLabel.text = weatherInfo.city.name;
    
    [self._iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DetailIconURLTemplate, weatherInfo.icon]]];
    self._stateLabel.text = weatherInfo.state;
    self._temperatureLabel.text = [FormatterHelper formatTemperature:weatherInfo.temperature];
    self._humidityLabel.text = [FormatterHelper formatHumidity:weatherInfo.humidity];
    self._windSpeedLabel.text = [FormatterHelper formatWindSpeed:weatherInfo.windSpeed];
    
    self._footerLabel.text = [[NSString stringWithFormat:@"Weather information for %@ received on %@", weatherInfo.city.name, [FormatterHelper formatDate:weatherInfo.date]] uppercaseString];
}

@end
