//
//  CommonViewController.m
//  PlanRadar Weather
//
//  Created by worker on 19/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "CommonViewController.h"

#import "BackgroundView.h"
#import "ImageBackgroundView.h"

@import SVProgressHUD;

@interface CommonViewController ()

@end

@implementation CommonViewController

- (void)loadView {
    self.view = [[ImageBackgroundView alloc] initWithFrame:UIScreen.mainScreen.bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupUI];
    [self _setupAutoLayout];
}

@end

@implementation CommonViewController (LoadingOverlay)

- (void)showLoadingOverlay {
    if ([SVProgressHUD isVisible]) {
        return;
    }
    [SVProgressHUD show];
}

- (void)hideLoadingOverlay {
    if (![SVProgressHUD isVisible]) {
        return;
    }
    [SVProgressHUD dismiss];
}

@end

@implementation CommonViewController (SetupUI)

- (void)_setupUI {
    
}

- (void)_setupAutoLayout {
    
}

@end

@implementation CommonViewController (ErrorHandling)

- (void)_showError:(NSError *)error {
    if (!error) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:error.localizedFailureReason ?: error.localizedRecoverySuggestion ?: error.localizedDescription
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    [self _showAlertController:alertController];
}

- (void)_showAlertController:(UIAlertController *)alertController {
    if (NSThread.isMainThread) {
        [self presentViewController:alertController
                           animated:true
                         completion:nil];
    }
    else {
        [NSOperationQueue.mainQueue addOperationWithBlock:^{
            [self presentViewController:alertController
                               animated:true
                             completion:nil];
        }];
    }
}

@end
