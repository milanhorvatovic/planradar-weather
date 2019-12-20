//
//  CitiesListViewController.m
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "CitiesListViewController.h"

#import "AppDelegate.h"
#import "DataProvider.h"
#import "City+CoreDataProperties.h"
#import "FetchedResultsControllerDelegate.h"

#import "CitiesListCell.h"
#import "CitySeachViewController.h"
#import "CityDetailViewController.h"

@interface CitiesListViewController (CreateUI)

- (UIBarButtonItem *)_createAddButton;
- (UITableView *)_createTableView;

@end

@interface CitiesListViewController (Action)

- (void)_addButtonAction;

@end

@interface CitiesListViewController (TableViewDataSource) <UITableViewDataSource>
@end
@interface CitiesListViewController (TableViewDelegate) <UITableViewDelegate>
@end

@interface CitiesListViewController ()

@property (nonnull, readwrite, strong, nonatomic) id<FetchDataProvider> dataProvider;

@property (nonnull, readwrite, strong, nonatomic) NSFetchedResultsController *_resultsController;

@property (nonnull, readwrite, strong, nonatomic) FetchedResultsControllerDelegate *_resultsControllerDelegate;


@property (nullable, readwrite, strong, nonatomic) UITableView *_tableView;

@end

@implementation CitiesListViewController

- (instancetype)initWithFetchDataProvider:(id<FetchDataProvider>)dataProvider {
    if (self = [self initWithNibName:nil
                              bundle:nil]) {
        self.dataProvider = dataProvider;
        self._resultsControllerDelegate = [[FetchedResultsControllerDelegate alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self._resultsController = [self.dataProvider fetchCities];
    self._resultsController.delegate = self._resultsControllerDelegate;
    NSError *error;
    if (![self._resultsController performFetch:&error]) {
        @throw [NSException exceptionWithName:@"Perform fetch"
                                       reason:[NSString stringWithFormat:@"Fetch failed due to %@", error]
                                     userInfo:nil];
    }
}

@end

@implementation CitiesListViewController (SetupUI)

- (void)_setupUI {
    [super _setupUI];
    
    self.title = @"CITIES";
    
    UIBarButtonItem *addItem = [self _createAddButton];
    self.navigationItem.rightBarButtonItem = addItem;
    
    self._tableView = [self _createTableView];
    [self.view addSubview:self._tableView];
    self._tableView.dataSource = self;
    self._tableView.delegate = self;
    self._tableView.tableFooterView = [[UIView alloc] init];
    self._tableView.rowHeight = 48;
    
    self._resultsControllerDelegate.tableView = self._tableView;
}

- (void)_setupAutoLayout {
    [super _setupAutoLayout];
    
    if (@available(iOS 11, *)) {
        UILayoutGuide *layoutGuide = self.view.safeAreaLayoutGuide;
        [self._tableView.leftAnchor constraintEqualToAnchor:layoutGuide.leftAnchor].active = YES;
        [self._tableView.rightAnchor constraintEqualToAnchor:layoutGuide.rightAnchor].active = YES;
        [self._tableView.topAnchor constraintEqualToAnchor:layoutGuide.topAnchor].active = YES;
        [self._tableView.bottomAnchor constraintEqualToAnchor:layoutGuide.bottomAnchor].active = YES;
    }
    else {
        [self._tableView.leftAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
        [self._tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
        [self._tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
        [self._tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    }
    
}

@end

@implementation CitiesListViewController (CreateUI)

- (UIBarButtonItem *)_createAddButton {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                         target:self
                                                         action:@selector(_addButtonAction)];
}

- (UITableView *)_createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.backgroundColor = UIColor.clearColor;
    [tableView registerClass:CitiesListCell.class
      forCellReuseIdentifier:@"CityCellIdentifier"];
    return tableView;
}

@end

@implementation CitiesListViewController (Action)

- (void)_addButtonAction {
    AppDelegate *appDelegate = (AppDelegate *) UIApplication.sharedApplication.delegate;
    CitySeachViewController *viewController = [[CitySeachViewController alloc] initWithWeatherDataLoader:(id<WeatherDataLoader>) appDelegate.dataLoader
                                                                                        saveDataProvider:(id<SaveDataProvider>) appDelegate.dataProvider];
    [self presentViewController:viewController animated:YES completion:nil];
}

@end

@implementation CitiesListViewController (TableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self._resultsController.sections.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self._resultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CitiesListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCellIdentifier"
                                                           forIndexPath:indexPath];
    [cell configureWithCity:[self._resultsController objectAtIndexPath:indexPath]];
    return cell;
}

@end

@implementation CitiesListViewController (TableViewDelegate)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    City *city = [self._resultsController objectAtIndexPath:indexPath];
    if (!city) {
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *) UIApplication.sharedApplication.delegate;
    CityDetailViewController *viewController = [[CityDetailViewController alloc] initWithCity:city
                                                                            weatherDataLoader:(id<WeatherDataLoader>) appDelegate.dataLoader
                                                                             saveDataProvider:(id<SaveDataProvider>) appDelegate.dataProvider];
    [self presentViewController:viewController
                       animated:YES
                     completion:nil];
}

@end
