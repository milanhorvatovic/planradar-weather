//
//  LiveCityDetailViewController.m
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "LiveCityDetailViewController.h"
#import "CityDetailViewController_Protected.h"

#import "DataLoader.h"
#import "DataProvider.h"
#import "ModelServiceWeather.h"
#import "City+CoreDataProperties.h"

@interface CityDetailViewController (Configure)

- (void)_configureWithCity:(nonnull ModelServiceWeather *)weather;

@end

@interface LiveCityDetailViewController ()

@property (nonnull, readwrite, copy, nonatomic) NSString *cityName;
@property (nonnull, readwrite, strong, nonatomic) id<WeatherDataLoader> dataLoader;
@property (nonnull, readwrite, strong, nonatomic) id<SaveDataProvider> dataProvider;

@end

@implementation LiveCityDetailViewController

- (instancetype)initWithCity:(City *)city
           weatherDataLoader:(id<WeatherDataLoader>)dataLoader
            saveDataProvider:(id<SaveDataProvider>)dataProvider {
    if (self = [self initWithNibName:nil
                              bundle:nil]) {
        self.cityName = city.name;
        self.dataLoader = dataLoader;
        self.dataProvider = dataProvider;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self showLoadingOverlay];
    __weak typeof(self) weakSelf = self;
    [self.dataLoader loadWeatherWithName:self.cityName
                            completition:^(ModelServiceWeather * _Nullable object, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (error) {
            [strongSelf _showError:error];
        }
        else {
            [strongSelf.dataProvider saveWeather:object];
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [weakSelf hideLoadingOverlay];
                [weakSelf _configureWithCity:object];
            }];
        }
    }];
}

@end

@implementation LiveCityDetailViewController (Configure)

- (void)_configureWithCity:(nonnull ModelServiceWeather *)weather {
    self._titleLabel.text = weather.cityName;
    
    [self._iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:DetailIconURLTemplate, weather.icon]]];
    self._stateLabel.text = weather.state;
    self._temperatureLabel.text = [FormatterHelper formatTemperature:weather.temperature];
    self._humidityLabel.text = [FormatterHelper formatHumidity:weather.humidity];
    self._windSpeedLabel.text = [FormatterHelper formatWindSpeed:weather.windSpeed];
    
    self._footerLabel.text = [[NSString stringWithFormat:@"Weather information for %@ received on %@", weather.cityName, [FormatterHelper formatDate:weather.date]] uppercaseString];
}

@end
