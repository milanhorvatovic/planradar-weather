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
#import "DataLoader.h"
#import "City+CoreDataProperties.h"
#import "FetchedResultsControllerDelegate.h"

#import "CitiesListCell.h"
#import "CitySeachViewController.h"
#import "LiveCityDetailViewController.h"
#import "HistoryListViewController.h"

@interface CitiesListViewController (CreateUI)

- (UIBarButtonItem *)_createAddButton;
- (UITableView *)_createTableView;
- (UIRefreshControl *)_createPullToRefresh;
- (UIView *)_createEmptyBackgroundView;

@end

@interface CitiesListViewController (Action)

- (void)_addButtonAction;

- (void)_pullToRefreshAction;

@end

@interface CitiesListViewController (TableViewDataSource) <UITableViewDataSource>
@end
@interface CitiesListViewController (TableViewDelegate) <UITableViewDelegate>
@end

@interface CitiesListViewController ()

@property (nonnull, readwrite, strong, nonatomic) id<FetchDataProvider, SaveDataProvider, DeleteDataProvider> dataProvider;
@property (nonnull, readwrite, strong, nonatomic) id<WeatherDataLoader> dataLoader;

@property (nonnull, readwrite, strong, nonatomic) NSFetchedResultsController *_resultsController;

@property (nonnull, readwrite, strong, nonatomic) FetchedResultsControllerDelegate *_resultsControllerDelegate;


@property (nullable, readwrite, strong, nonatomic) UIRefreshControl *_pullToRefresh;
@property (nullable, readwrite, strong, nonatomic) UITableView *_tableView;

@end

@implementation CitiesListViewController

- (instancetype)initWithFetchDataProvider:(id<FetchDataProvider, SaveDataProvider, DeleteDataProvider>)dataProvider
                        weatherDataLoader:(id<WeatherDataLoader>)dataLoader {
    if (self = [self initWithNibName:nil
                              bundle:nil]) {
        self.dataProvider = dataProvider;
        self.dataLoader = dataLoader;
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
    self._tableView.backgroundView.alpha = self._resultsController.fetchedObjects.count > 0 ? 0 : 1;
}

@end

@implementation CitiesListViewController (SetupUI)

- (void)_setupUI {
    [super _setupUI];
    
    self.title = @"CITIES";
    
    __weak typeof(self) weakSelf = self;
    self._resultsControllerDelegate.completition = ^(NSInteger count) {
        [UIView animateWithDuration:0.25
                         animations:^{
            weakSelf._tableView.backgroundView.alpha = count > 0 ? 0 : 1;
        }];
    };
    
    UIBarButtonItem *addItem = [self _createAddButton];
    self.navigationItem.rightBarButtonItem = addItem;
    
    self._pullToRefresh = [self _createPullToRefresh];
    
    self._tableView = [self _createTableView];
    [self.view addSubview:self._tableView];
    self._tableView.dataSource = self;
    self._tableView.delegate = self;
    self._tableView.refreshControl = self._pullToRefresh;
    self._tableView.backgroundView = [self _createEmptyBackgroundView];
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

- (UIRefreshControl *)_createPullToRefresh {
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [refreshControl addTarget:self
                       action:@selector(_pullToRefreshAction)
             forControlEvents:UIControlEventValueChanged];
    return refreshControl;
}

- (UIView *)_createEmptyBackgroundView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColor.clearColor;
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:16
                                   weight:UIFontWeightSemibold];
    label.textColor = [UIColor colorNamed:@"NormalText"];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = @"You don't have any cities. To start use '+' button above.";
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:label];
    [label.centerYAnchor constraintEqualToAnchor:view.centerYAnchor].active = YES;
    [label.leftAnchor constraintEqualToAnchor:view.leftAnchor
                                     constant:10].active = YES;
    [label.rightAnchor constraintEqualToAnchor:view.rightAnchor
                                      constant:10].active = YES;
    
    return view;
}

@end

@implementation CitiesListViewController (Action)

- (void)_addButtonAction {
    AppDelegate *appDelegate = (AppDelegate *) UIApplication.sharedApplication.delegate;
    CitySeachViewController *viewController = [[CitySeachViewController alloc] initWithWeatherDataLoader:(id<WeatherDataLoader>) appDelegate.dataLoader
                                                                                        saveDataProvider:(id<SaveDataProvider>) appDelegate.dataProvider];
    [self presentViewController:viewController
                       animated:YES
                     completion:nil];
}

- (void)_pullToRefreshAction {
    NSMutableArray<NSNumber *> *ids = [[NSMutableArray alloc] init];
    for (City *city in self._resultsController.fetchedObjects) {
        [ids addObject:city.identifier];
    }
    
    if (!ids.count) {
        [self._pullToRefresh endRefreshing];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.dataLoader loadWeathersWithIds:ids
                            completition:^(NSArray<ModelServiceWeather *> * _Nullable object, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        if (error) {
            [strongSelf _showError:error];
        }
        else {
            [weakSelf.dataProvider saveWeathers:object];
        }
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [weakSelf._pullToRefresh endRefreshing];
        }];
    }];
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
    LiveCityDetailViewController *viewController = [[LiveCityDetailViewController alloc] initWithCity:city
                                                                                    weatherDataLoader:(id<WeatherDataLoader>) appDelegate.dataLoader
                                                                                     saveDataProvider:(id<SaveDataProvider>) appDelegate.dataProvider];
    [self presentViewController:viewController
                       animated:YES
                     completion:nil];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    City *city = [self._resultsController objectAtIndexPath:indexPath];
    if (!city) {
        return;
    }
    AppDelegate *appDelegate = (AppDelegate *) UIApplication.sharedApplication.delegate;
    HistoryListViewController *viewController = [[HistoryListViewController alloc] initWithCity:city
                                                                              fetchDataProvider:(id<FetchDataProvider>) appDelegate.dataProvider];
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle != UITableViewCellEditingStyleDelete) {
        return;
    }
    City *city = [self._resultsController objectAtIndexPath:indexPath];
    if (!city) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Confimation"
                                                                             message:[NSString stringWithFormat:@"Are you sure about deleting %@?", city.name]
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    [alertController addAction:[UIAlertAction actionWithTitle:@"Delete"
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        City *city = [self._resultsController objectAtIndexPath:indexPath];
        if (!city) {
            return;
        }
        [strongSelf.dataProvider deleteCity:city];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    [self presentViewController:alertController
                       animated:true
                     completion:nil];
}

@end
