//
//  ViewController.m
//  WeatherForecastApp
//
//  Created by wipro on 07/03/17.
//  Copyright (c) 2017 Wipro. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@property (strong, nonatomic) IBOutlet UITextField *txtCityName;
@property(strong,nonatomic) NSArray *tableData;
@property (weak, nonatomic) IBOutlet UITableView *tblViewWeatherForecast;
@property(strong,nonatomic) UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *btnGetWeatherForecast;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewCurrentWeather;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentDateAndTime;



@end

@implementation ViewController

@synthesize tableData;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Default Location
    [self getWeatherForcecast:@"Bangalore"];
    
    self.tblViewWeatherForecast.dataSource = self;
    self.tblViewWeatherForecast.delegate = self;
    self.btnGetWeatherForecast.enabled = YES;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.center=self.view.center;
    [self.view addSubview:self.activityIndicator];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnGetWeatherForecastClick:(id)sender
{
    [self getWeatherForcecast: self.txtCityName.text];
    [self.activityIndicator startAnimating];
    self.btnGetWeatherForecast.enabled = NO;
    
    
}

-(void)configureCurrentWeatherView
{
    
    WeatherMetaData *currentMetaData = [self.tableData objectAtIndex:1];
    
    
    self.lblCurrentLocation.text = currentMetaData.locationName;
    self.lblCurrentTemperature.text = [NSString stringWithFormat:@"%@°C",[currentMetaData.temperature stringValue]];

    
    
    NSDateFormatter *parsingFormatter = [NSDateFormatter new];
    [parsingFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [parsingFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *date = [parsingFormatter dateFromString:currentMetaData.date];
    NSLog(@"date: %@", date);
    
    NSDateFormatter *displayingFormatter = [NSDateFormatter new];
    [displayingFormatter setDateFormat:@"dd LLL yyyy hh:mm a"];
    NSString *display = [displayingFormatter stringFromDate:date];
    NSLog(@"display: %@", display); // 2014-04-18T17:34:19
    self.lblCurrentDateAndTime.text = [NSString stringWithFormat:@"as of %@ GMT ",display];


    
    //Setting the image
    NSArray* strIconArray = (NSArray*)currentMetaData .icon;
    NSString *strIconName = [strIconArray firstObject];
    NSString *trimmedIcon = [strIconName stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    NSString *path = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",trimmedIcon];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    [self.imgViewCurrentWeather setImage:img];
    
    
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *weatherCellIdentifier = @"WeatherCell";
    
    WeatherCell *cell = (WeatherCell *)[tableView dequeueReusableCellWithIdentifier:weatherCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"WeatherCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    WeatherMetaData *weatherMetaData = [self.tableData objectAtIndex:indexPath.row + 2];
    
    cell.lblTempMax.text = [NSString stringWithFormat:@"Temperature : %@°C",[weatherMetaData.tempHigh stringValue]];
   
    cell.lblHumidity.text = [NSString stringWithFormat:@"Humidity: %@%%",[weatherMetaData.humidity stringValue]];
    
    NSArray *arrWeather = [NSArray arrayWithArray: weatherMetaData.condition];
    cell.lblWeather.text = [arrWeather firstObject];

    NSDateFormatter *parsingFormatter = [NSDateFormatter new];
    [parsingFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [parsingFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    NSDate *date = [parsingFormatter dateFromString:weatherMetaData.date];
    NSLog(@"date: %@", date);
    
    NSDateFormatter *displayingFormatter = [NSDateFormatter new];
    [displayingFormatter setDateFormat:@"dd LLL yyyy hh:mm a"];
    NSString *display = [displayingFormatter stringFromDate:date];
    NSLog(@"display: %@", display);
    cell.lblTime.text = display;
    
    
    
   
    
    
    
    
    NSArray* strIconArray = (NSArray*)weatherMetaData.icon;
    
    NSString *strIconName = [strIconArray firstObject];
    
    NSString *trimmedIcon = [strIconName stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    NSString *path = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",trimmedIcon];
    
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    
    [cell.imgWeather setImage:img];
    
    return cell;

}





-(void)getWeatherForcecast : (NSString *) cityName
{
    NSString *apiKey = @"ce812c30f6a9160a13e7bbfe6c9fbcb0";
    
    
    NSString *city = @"Bangalore";
    
    if(cityName)
    {
        city = cityName;
    }
    else
    {
        city = @"Bangalore";
    }
    
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *weatherURL = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?q=%@&units=metric&APPID=%@",city,apiKey];
    NSURL *url = [NSURL URLWithString:weatherURL];
    
    // Asynchronously API is hit here
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSLog(@"%@",data);
                                          if (error)
                                          {
                                              NSLog(@"Error %@",error.description);
                                              [self.activityIndicator stopAnimating];
                                              self.btnGetWeatherForecast.enabled = YES;
                                              
                                              if ([UIAlertController class])
                                              {
                                                  
                                                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Weather Details Not Found" message:@"Unable to find the weather details for this city. Please check the spelling of the city or try again later." preferredStyle:UIAlertControllerStyleAlert];
                                                  
                                                  UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                                                  [alertController addAction:ok];
                                                  
                                                  [self presentViewController:alertController animated:YES completion:nil];
                                                  
                                              } 
                                              else 
                                              {
                                                  
                                                  UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Weather Details Not Found" message:@"Unable to find the weather details for this city. Please check the spelling of the city or try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                                  
                                                  [alert show];
                                                  
                                              }
                                          }
                                          else
                                          {
                                              NSDictionary *json  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              NSLog(@"%@",json);
                                              
                                              [self parseWeatherForecastData:json];
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  
                                                  [self configureCurrentWeatherView];
                                                  
                                                  [self.tblViewWeatherForecast reloadData];
                                                  
                                                  [self.activityIndicator stopAnimating];
                                                  self.btnGetWeatherForecast.enabled = YES;
                                              });
                                              
                                              
                                          }
                                          
                                          
                                      }];
    [dataTask resume];
    
    
}


-(void)parseWeatherForecastData : (NSDictionary *)dictCompleteWeatherData
{
    
    NSMutableArray *arrWeatherForecastRowsList = [[NSMutableArray alloc] init];
    
    //parsing the weather values
    NSArray *arrListForecast = [dictCompleteWeatherData valueForKey:@"list"];
    for (int i=0 ; i < [arrListForecast count];i++)
    {
        WeatherMetaData *weatherMetaData = [[WeatherMetaData alloc] init];
        
        NSDictionary *dictListLoop = [arrListForecast objectAtIndex:i];
        
        NSDictionary *dictMain = [dictListLoop valueForKey:@"main"];
        weatherMetaData.humidity = [dictMain valueForKey:@"humidity"];
        weatherMetaData.tempHigh = [dictMain valueForKey:@"temp_max"];
        weatherMetaData.tempHigh = [dictMain valueForKey:@"temp_min"];
        weatherMetaData.temperature = [dictMain valueForKey:@"temp"];
        
        NSDictionary *dictWeather = [dictListLoop valueForKey:@"weather"];
        weatherMetaData.condition = [dictWeather valueForKey:@"main"];
        weatherMetaData.conditionDescription = [dictWeather valueForKey:@"description"];
        weatherMetaData.icon = [dictWeather valueForKey:@"icon"];
        
        NSDictionary *dictCity = [dictCompleteWeatherData valueForKey:@"city"];
        weatherMetaData.locationName = [dictCity valueForKey:@"name"];
        
        weatherMetaData.date = [dictListLoop valueForKey:@"dt_txt"];
        
        [arrWeatherForecastRowsList addObject:weatherMetaData];
        
    }
    
    if([arrWeatherForecastRowsList count] > 0)
    {
        self.tableData = [NSArray arrayWithArray:arrWeatherForecastRowsList];
    }
    
}





@end
