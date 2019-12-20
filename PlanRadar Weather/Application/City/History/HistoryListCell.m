//
//  HistoryListCell.m
//  PlanRadar Weather
//
//  Created by worker on 20/12/2019.
//  Copyright © 2019 Milan Horvatovic. All rights reserved.
//

#import "HistoryListCell.h"

#import "WeatherInfo+CoreDataProperties.h"
#import "FormatterHelper.h"

@interface HistoryListCell (CreateUI)

- (UIStackView *)_createVerticalStackView;

- (UILabel *)_createDateLabel;
- (UILabel *)_createTitleLabel;

@end

@interface HistoryListCell ()

@property (nullable, readwrite, strong, nonatomic) UILabel *_dateLabel;
@property (nullable, readwrite, strong, nonatomic) UILabel *_titleLabel;

@end

@implementation HistoryListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = UIColor.clearColor;
        
        UIStackView *stackView = [self _createVerticalStackView];
        self._dateLabel = [self _createDateLabel];
        self._titleLabel = [self _createTitleLabel];
        [stackView addArrangedSubview:self._dateLabel];
        [stackView addArrangedSubview:self._titleLabel];
        
        [self.contentView addSubview:stackView];
        
        [stackView.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor
                                             constant:16].active = YES;
        [stackView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
        [stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor
                                            constant:17].active = YES;
        [stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor
                                               constant:-17].active = YES;
    }
    return self;
}

@end

@implementation HistoryListCell (CreateUI)

- (UIStackView *)_createVerticalStackView {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    return stackView;
}

- (UILabel *)_createDateLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12
                                   weight:UIFontWeightBold];
    label.textColor = [UIColor colorNamed:@"NormalText"];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

- (UILabel *)_createTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:17
                                   weight:UIFontWeightRegular];
    label.textColor = [UIColor colorNamed:@"Tint"];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

@end


@implementation HistoryListCell (Configure)

- (void)configureWithWeatherInfo:(nonnull WeatherInfo *)weatherInfo {
    self._dateLabel.text = [FormatterHelper formatDate:weatherInfo.date];
    self._titleLabel.text = [@[weatherInfo.state,
                               [FormatterHelper formatTemperature:weatherInfo.temperature]]
                             componentsJoinedByString:@", "];
}

@end
