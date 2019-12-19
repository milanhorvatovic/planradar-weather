//
//  CitiesListCell.m
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "CitiesListCell.h"

#import "City+CoreDataProperties.h"

@implementation CitiesListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.clearColor;
        self.textLabel.textColor = [UIColor colorNamed:@"NormalText"];
        self.textLabel.font = [UIFont systemFontOfSize:15
                                                weight:UIFontWeightBold];
    }
    return self;
}

@end

@implementation CitiesListCell (Configure)

- (void)configureWithCity:(nonnull City *)city {
    NSArray<NSString *> *parts = @[city.name, city.countryCode];
    self.textLabel.text = [parts componentsJoinedByString:@", "];
}

@end
