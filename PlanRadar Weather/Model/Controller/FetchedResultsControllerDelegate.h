//
//  FetchedResultsControllerDelegate.h
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

@import UIKit;

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@interface FetchedResultsControllerDelegate: NSObject <NSFetchedResultsControllerDelegate>

typedef void (^FetchedResultsControllerCountChangedCompletition) (NSInteger count);

@property (nullable, readwrite, strong, nonatomic) UITableView *tableView;

@property (nullable, readwrite, copy, nonatomic) FetchedResultsControllerCountChangedCompletition completition;

@end

NS_ASSUME_NONNULL_END
