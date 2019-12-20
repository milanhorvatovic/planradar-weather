//
//  CommonViewController.h
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface CommonViewController: UIViewController

@end

@interface CommonViewController (LoadingOverlay)

- (void)showLoadingOverlay;
- (void)hideLoadingOverlay;

@end

@interface CommonViewController (SetupUI)

- (void)_setupUI;
- (void)_setupAutoLayout;

@end

@interface CommonViewController (ShowError)

- (void)_showError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
