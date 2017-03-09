//
//  WeatherMetaData.h
//  WeatherForecastApp
//
//  Created by wipro on 07/03/17.
//  Copyright (c) 2017 Wipro. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WeatherMetaData : NSObject


@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSNumber *humidity;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *tempHigh;
@property (nonatomic, strong) NSNumber *tempLow;

@property (nonatomic, strong) NSString *conditionDescription;
@property (nonatomic, strong) NSString *condition;
@property (nonatomic,strong)  NSString *iconName;


@property (nonatomic, strong) NSString *locationName;
@property (nonatomic, strong) NSDate *sunrise;
@property (nonatomic, strong) NSDate *sunset;

@property (nonatomic, strong) NSNumber *windBearing;
@property (nonatomic, strong) NSNumber *windSpeed;
@property (nonatomic, strong) NSString *icon;


@end
