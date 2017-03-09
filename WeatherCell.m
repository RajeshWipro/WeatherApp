//
//  WeatherCell.m
//  WeatherForecastApp
//
//  Created by wipro on 08/03/17.
//  Copyright (c) 2017 Wipro. All rights reserved.
//

#import "WeatherCell.h"

@implementation WeatherCell

@synthesize lblTime;
@synthesize lblTempMax;
@synthesize lblHumidity;
@synthesize imgWeather;
@synthesize lblWeather;
@synthesize lblWeatherDescription;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
