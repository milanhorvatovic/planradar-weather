//
//  HistoryListViewController.m
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "HistoryListViewController.h"

#import "DataProvider.h"
#import "City+CoreDataProperties.h"
#import "FetchedResultsControllerDelegate.h"

#import "HistoryListCell.h"
#import "StaticCityDetailViewController.h"

@interface HistoryListViewController (CreateUI)

- (UITableView *)_createTableView;

@end

@interface HistoryListViewController (TableViewDataSource) <UITableViewDataSource>
@end
@interface HistoryListViewController (TableViewDelegate) <UITableViewDelegate>
@end

@interface HistoryListViewController ()

@property (nonnull, readwrite, strong, nonatomic) City *city;

@property (nonnull, readwrite, strong, nonatomic) id<FetchDataProvider> dataProvider;

@property (nonnull, readwrite, strong, nonatomic) NSFetchedResultsController *_resultsController;

@property (nonnull, readwrite, strong, nonatomic) FetchedResultsControllerDelegate *_resultsControllerDelegate;

@property (nullable, readwrite, strong, nonatomic) UITableView *_tableView;

@end

@implementation HistoryListViewController

- (instancetype)initWithCity:(City *)city
           fetchDataProvider:(id<FetchDataProvider>)dataProvider {
    if (self = [self initWithNibName:nil
                              bundle:nil]) {
        self.city = city;
        self.dataProvider = dataProvider;
        self._resultsControllerDelegate = [[FetchedResultsControllerDelegate alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self._resultsController = [self.dataProvider fetchWeatherInfosForCity:self.city];
    self._resultsController.delegate = self._resultsControllerDelegate;
    NSError *error;
    if (![self._resultsController performFetch:&error]) {
        @throw [NSException exceptionWithName:@"Perform fetch"
                                       reason:[NSString stringWithFormat:@"Fetch failed due to %@", error]
                                     userInfo:nil];
    }
}

@end

@implementation HistoryListViewController (SetupUI)

- (void)_setupUI {
    [super _setupUI];
    
    self.title = [[NSString stringWithFormat:@"%@\nHISTORICAL", self.city.name] uppercaseString];
    
    self._tableView = [self _createTableView];
    [self.view addSubview:self._tableView];
    self._tableView.dataSource = self;
    self._tableView.delegate = self;
    self._tableView.tableFooterView = [[UIView alloc] init];
    self._tableView.rowHeight = UITableViewAutomaticDimension;
    self._tableView.estimatedRowHeight = 72;
    
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

@implementation HistoryListViewController (CreateUI)

- (UITableView *)_createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStylePlain];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    tableView.backgroundColor = UIColor.clearColor;
    [tableView registerClass:HistoryListCell.class
      forCellReuseIdentifier:@"HistoryCellIdentifier"];
    return tableView;
}

@end

@implementation HistoryListViewController (TableViewDataSource)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self._resultsController.sections.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = self._resultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCellIdentifier"
                                                           forIndexPath:indexPath];
    [cell configureWithWeatherInfo:[self._resultsController objectAtIndexPath:indexPath]];
    return cell;
}

@end

@implementation HistoryListViewController (TableViewDelegate)

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    WeatherInfo *weatherInfo = [self._resultsController objectAtIndexPath:indexPath];
    if (!weatherInfo) {
        return;
    }
    StaticCityDetailViewController *viewController = [[StaticCityDetailViewController alloc] initWithWeatherInfo:weatherInfo];
    [self presentViewController:viewController
                       animated:YES
                     completion:nil];
}

@end
