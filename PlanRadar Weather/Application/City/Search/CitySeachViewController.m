//
//  CitySeachViewController.m
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "CitySeachViewController.h"

#import "DataLoader.h"
#import "DataProvider.h"

@interface CitySeachViewController (CreateUI)

- (UILabel *)_createTitleLabel;
- (UISearchBar *)_createSearchBar;

@end

@interface CitySeachViewController (SearchBarDelegate) <UISearchBarDelegate>
@end

@interface CitySeachViewController ()

@property (nonnull, readwrite, strong, nonatomic) id<WeatherDataLoader> dataLoader;
@property (nonnull, readwrite, strong, nonatomic) id<SaveDataProvider> dataProvider;

@property (nullable, readwrite, strong, nonatomic) UILabel *_titleLabel;
@property (nullable, readwrite, strong, nonatomic) UISearchBar *_searchBar;

@end

@implementation CitySeachViewController

- (instancetype)initWithWeatherDataLoader:(id<WeatherDataLoader>)dataLoader
                         saveDataProvider:(id<SaveDataProvider>)dataProvider {
    if (self = [self initWithNibName:nil
                              bundle:nil]) {
        self.dataLoader = dataLoader;
        self.dataProvider = dataProvider;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self._searchBar becomeFirstResponder];
}

@end

@implementation CitySeachViewController (SetupUI)

- (void)_setupUI {
    [super _setupUI];
    
    self._titleLabel = [self _createTitleLabel];
    self._searchBar = [self _createSearchBar];
    [self.view addSubview:self._titleLabel];
    [self.view addSubview:self._searchBar];
    
    self._searchBar.delegate = self;
}

- (void)_setupAutoLayout {
    [super _setupAutoLayout];
    
    if (@available(iOS 11, *)) {
        UILayoutGuide *layoutGuide = self.view.safeAreaLayoutGuide;
        [self._titleLabel.leftAnchor constraintEqualToAnchor:layoutGuide.leftAnchor
                                                    constant:15].active = YES;
        [self._titleLabel.rightAnchor constraintEqualToAnchor:layoutGuide.rightAnchor
                                                     constant:15].active = YES;
        [self._titleLabel.topAnchor constraintEqualToAnchor:layoutGuide.topAnchor
                                                   constant:15].active = YES;
        
        [self._searchBar.leftAnchor constraintEqualToAnchor:layoutGuide.leftAnchor].active = YES;
        [self._searchBar.rightAnchor constraintEqualToAnchor:layoutGuide.rightAnchor].active = YES;
    }
    else {
        [self._titleLabel.leftAnchor constraintEqualToAnchor:self.view.leadingAnchor
                                                    constant:15].active = YES;
        [self._titleLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor
                                                     constant:15].active = YES;
        [self._titleLabel.topAnchor constraintEqualToAnchor:self.view.topAnchor
                                                   constant:15].active = YES;
        
        [self._searchBar.leftAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
        [self._searchBar.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    }
    
    [self._searchBar.topAnchor constraintEqualToAnchor:self._titleLabel.bottomAnchor
                                              constant:10].active = YES;
}

@end

@implementation CitySeachViewController (CreateUI)

- (UILabel *)_createTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:13
                                   weight:UIFontWeightRegular];
    label.text = @"Enter city, postcode or airport location";
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (UISearchBar *)_createSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.barStyle = UIBarStyleDefault;
    searchBar.backgroundColor = UIColor.clearColor;
    [searchBar setBackgroundImage:[[UIImage alloc] init]];
    searchBar.showsCancelButton = YES;
    searchBar.placeholder = @"Search";
    searchBar.keyboardType = UIKeyboardTypeDefault;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    return searchBar;
}

@end

@implementation CitySeachViewController (SearchBarDelegate)

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *text = searchBar.text;
    if (text.length == 0) {
        return;
    }
    [self.view endEditing:YES];
    [self showLoadingOverlay];
    __weak typeof(self) weakSelf = self;
    [self.dataLoader loadWeatherWithName:text
                            completition:^(ModelServiceWeather * _Nullable object, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (error) {
            [strongSelf _showError:error];
        }
        else {
            [strongSelf.dataProvider saveWeather:object];
            [NSOperationQueue.mainQueue addOperationWithBlock:^{
                [weakSelf hideLoadingOverlay];
                [weakSelf dismissViewControllerAnimated:YES
                                             completion:nil];
            }];
        }
    }];
}

@end
