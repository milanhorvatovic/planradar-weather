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

@property (nullable, readwrite, strong, nonatomic) UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
