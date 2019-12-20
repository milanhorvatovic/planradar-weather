//
//  CityDetailViewController.m
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "CityDetailViewController.h"

#import "DataLoader.h"
#import "DataProvider.h"
#import "ModelServiceWeather.h"
#import "FormatterHelper.h"
#import "City+CoreDataProperties.h"

#import "CorneredView.h"

@interface CityDetailViewController (CreateUI)

- (UIStackView *)_createHorizontalStackView;
- (UIStackView *)_createVerticalStackView;
- (UILabel *)_createDataTitleLabelWithTitle:(NSString *)title;
- (UILabel *)_createDataValueLabel;

- (UIButton *)_createCloseButton;
- (UILabel *)_createTitleLabel;
- (UIView *)_createContentView;
- (UILabel *)_createFooterLabel;

@end

@interface CityDetailViewController (Action)

- (void)_closeButtonAction;

@end


@interface CityDetailViewController (Configure)

- (void)_configureWithCity:(nonnull ModelServiceWeather *)weather;

@end

@interface CityDetailViewController ()

@property (nonnull, readwrite, copy, nonatomic) NSString *cityName;
@property (nonnull, readwrite, strong, nonatomic) id<WeatherDataLoader> dataLoader;
@property (nonnull, readwrite, strong, nonatomic) id<SaveDataProvider> dataProvider;

@property (nullable, readwrite, strong, nonatomic) UIButton *_closeButton;
@property (nullable, readwrite, strong, nonatomic) UILabel *_titleLabel;
@property (nullable, readwrite, strong, nonatomic) UIView *_contentView;
@property (nullable, readwrite, strong, nonatomic) UIStackView *_dataStackView;
@property (nullable, readwrite, strong, nonatomic) UILabel *_stateLabel;
@property (nullable, readwrite, strong, nonatomic) UILabel *_temperatureLabel;
@property (nullable, readwrite, strong, nonatomic) UILabel *_humidityLabel;
@property (nullable, readwrite, strong, nonatomic) UILabel *_windSpeedLabel;

@property (nullable, readwrite, strong, nonatomic) UILabel *_footerLabel;

@end

@implementation CityDetailViewController

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

@implementation CityDetailViewController (SetupUI)

- (void)_setupUI {
    [super _setupUI];
    
    self._closeButton = [self _createCloseButton];
    self._titleLabel = [self _createTitleLabel];
    self._contentView = [self _createContentView];
    self._dataStackView = [self _createVerticalStackView];
    {
        UIStackView *stackView = [self _createHorizontalStackView];
        stackView.alignment = UIStackViewAlignmentBottom;
        stackView.distribution = UIStackViewDistributionFill;
        UILabel *label = [self _createDataTitleLabelWithTitle:@"DESCRIPTION"];
        self._stateLabel = [self _createDataValueLabel];
        [label setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                 forAxis:UILayoutConstraintAxisHorizontal];
        [self._stateLabel setContentHuggingPriority:UILayoutPriorityDefaultLow
                                            forAxis:UILayoutConstraintAxisHorizontal];
        [stackView addArrangedSubview:label];
        [stackView addArrangedSubview:self._stateLabel];
        [self._dataStackView addArrangedSubview:stackView];
    }
    {
        UIStackView *stackView = [self _createHorizontalStackView];
        UILabel *label = [self _createDataTitleLabelWithTitle:@"TEMPERATURE"];
        self._temperatureLabel = [self _createDataValueLabel];
        [label setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                 forAxis:UILayoutConstraintAxisHorizontal];
        [self._temperatureLabel setContentHuggingPriority:UILayoutPriorityDefaultLow
                                            forAxis:UILayoutConstraintAxisHorizontal];
        [stackView addArrangedSubview:label];
        [stackView addArrangedSubview:self._temperatureLabel];
        [self._dataStackView addArrangedSubview:stackView];
    }
    {
        UIStackView *stackView = [self _createHorizontalStackView];
        UILabel *label = [self _createDataTitleLabelWithTitle:@"HUMIDITY"];
        self._humidityLabel = [self _createDataValueLabel];
        [label setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                 forAxis:UILayoutConstraintAxisHorizontal];
        [self._humidityLabel setContentHuggingPriority:UILayoutPriorityDefaultLow
                                            forAxis:UILayoutConstraintAxisHorizontal];
        [stackView addArrangedSubview:label];
        [stackView addArrangedSubview:self._humidityLabel];
        [self._dataStackView addArrangedSubview:stackView];
    }
    {
        UIStackView *stackView = [self _createHorizontalStackView];
        UILabel *label = [self _createDataTitleLabelWithTitle:@"WINDSPEED"];
        self._windSpeedLabel = [self _createDataValueLabel];
        [label setContentHuggingPriority:UILayoutPriorityDefaultHigh
                                 forAxis:UILayoutConstraintAxisHorizontal];
        [self._windSpeedLabel setContentHuggingPriority:UILayoutPriorityDefaultLow
                                            forAxis:UILayoutConstraintAxisHorizontal];
        [stackView addArrangedSubview:label];
        [stackView addArrangedSubview:self._windSpeedLabel];
        [self._dataStackView addArrangedSubview:stackView];
    }
    [self._dataStackView setContentHuggingPriority:UILayoutPriorityRequired
                                           forAxis:UILayoutConstraintAxisVertical];
    [self._contentView addSubview:self._dataStackView];
    
    [self._footerLabel setContentHuggingPriority:UILayoutPriorityDefaultLow
                                         forAxis:UILayoutConstraintAxisVertical];
    self._footerLabel = [self _createFooterLabel];
    
    [self.view addSubview:self._closeButton];
    [self.view addSubview:self._titleLabel];
    [self.view addSubview:self._contentView];
    [self.view addSubview:self._footerLabel];
    
}

- (void)_setupAutoLayout {
    [super _setupAutoLayout];
    
    if (@available(iOS 11, *)) {
        UILayoutGuide *layoutGuide = self.view.safeAreaLayoutGuide;
        [self._closeButton.leftAnchor constraintEqualToAnchor:layoutGuide.leftAnchor].active = YES;
        [self._closeButton.topAnchor constraintEqualToAnchor:layoutGuide.topAnchor].active = YES;
        
        [self._titleLabel.centerXAnchor constraintEqualToAnchor:layoutGuide.centerXAnchor].active = YES;
        [self._titleLabel.topAnchor constraintEqualToAnchor:layoutGuide.topAnchor
                                                   constant:15].active = YES;
        
        [self._contentView.centerXAnchor constraintEqualToAnchor:layoutGuide.centerXAnchor].active = YES;
        [self._contentView.widthAnchor constraintEqualToAnchor:layoutGuide.widthAnchor
                                                    multiplier:0.8].active = YES;
        
        [self._footerLabel.leftAnchor constraintEqualToAnchor:layoutGuide.leftAnchor
                                                     constant:20].active = YES;
        [self._footerLabel.rightAnchor constraintEqualToAnchor:layoutGuide.rightAnchor
                                                      constant:-20].active = YES;
        [self._footerLabel.bottomAnchor constraintEqualToAnchor:layoutGuide.bottomAnchor
                                                       constant:-20].active = YES;
        
    }
    else {
        [self._closeButton.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
        [self._closeButton.topAnchor constraintEqualToAnchor:self.topLayoutGuide.topAnchor].active = YES;
        
        [self._titleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
        [self._titleLabel.topAnchor constraintEqualToAnchor:self.topLayoutGuide.topAnchor
                                                   constant:15].active = YES;
        
        [self._contentView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
        [self._contentView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor
                                                    multiplier:0.8].active = YES;
        
        [self._footerLabel.leftAnchor constraintEqualToAnchor:self.view.leftAnchor
                                                     constant:20].active = YES;
        [self._footerLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor
                                                      constant:-20].active = YES;
        [self._footerLabel.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.bottomAnchor
                                                       constant:-20].active = YES;
    }
    
    [self._closeButton.widthAnchor constraintEqualToConstant:40].active = true;
    [self._closeButton.heightAnchor constraintEqualToConstant:40].active = true;
    
    [self._titleLabel.leftAnchor constraintGreaterThanOrEqualToAnchor:self._closeButton.rightAnchor
                                                constant:5].active = YES;
    
    [self._contentView.topAnchor constraintEqualToAnchor:self._closeButton.bottomAnchor
                                                constant:10].active = YES;
    [self._contentView.bottomAnchor constraintLessThanOrEqualToAnchor:self._footerLabel.topAnchor
                                                             constant:-20].active = YES;
    
    [self._dataStackView.leftAnchor constraintEqualToAnchor:self._contentView.leftAnchor
                                                   constant:20].active = YES;
    [self._dataStackView.rightAnchor constraintEqualToAnchor:self._contentView.rightAnchor
                                                    constant:-20].active = YES;
    [self._dataStackView.topAnchor constraintEqualToAnchor:self._contentView.topAnchor
                                                  constant:20].active = YES;
    [self._dataStackView.bottomAnchor constraintEqualToAnchor:self._contentView.bottomAnchor
                                                     constant:-20].active = YES;
}

@end

@implementation CityDetailViewController (CreateUI)

- (UIStackView *)_createHorizontalStackView {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    return stackView;
}

- (UIStackView *)_createVerticalStackView {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    return stackView;
}

- (UILabel *)_createDataTitleLabelWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorNamed:@"NormalText"];
    label.font = [UIFont systemFontOfSize:12
                                   weight:UIFontWeightBold];
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 1;
    label.text = title;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (UILabel *)_createDataValueLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorNamed:@"Tint"];
    label.font = [UIFont systemFontOfSize:20
                                   weight:UIFontWeightSemibold];
    label.textAlignment = NSTextAlignmentRight;
    label.numberOfLines = 1;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (UIButton *)_createCloseButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"X"
            forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor colorNamed:@"ActionColor"];
    button.titleLabel.font = [UIFont systemFontOfSize:17
                                               weight:UIFontWeightBold];
    [button addTarget:self
               action:@selector(_closeButtonAction)
     forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    return button;
}

- (UILabel *)_createTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorNamed:@"NormalText"];
    label.font = [UIFont systemFontOfSize:17
                                   weight:UIFontWeightBold];
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (UIView *)_createContentView {
    CorneredView *view = [[CorneredView alloc] init];
    view.backgroundColor = [UIColor colorNamed:@"BackgroundColor"];
    view.cornerRadius = 25;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

- (UILabel *)_createFooterLabel {
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.textColor = [UIColor colorNamed:@"SecondaryText"];
    label.font = [UIFont systemFontOfSize:12
                                   weight:UIFontWeightRegular];
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

@end

@implementation CityDetailViewController (Action)

- (void)_closeButtonAction {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

@end

@implementation CityDetailViewController (Configure)

- (void)_configureWithCity:(nonnull ModelServiceWeather *)weather {
    self._titleLabel.text = weather.cityName;
    
    self._stateLabel.text = weather.state;
    self._temperatureLabel.text = [FormatterHelper formatTemperature:weather.temperature];
    self._humidityLabel.text = [FormatterHelper formatHumidity:weather.humidity];
    self._windSpeedLabel.text = [FormatterHelper formatWindSpeed:weather.windSpeed];
    
    self._footerLabel.text = [[NSString stringWithFormat:@"Weather information for %@ received on %@", weather.cityName, [FormatterHelper formatDate:weather.date]] uppercaseString];
}

@end
