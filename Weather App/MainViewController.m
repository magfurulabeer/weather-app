//
//  MainViewController.m
//  Weather App
//
//  Created by Magfurul Abeer on 3/1/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *hiTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *loTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (strong, nonatomic) NSString *apiKey;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) NSUInteger cityID;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.apiKey = @"e9da352d7560223033ad539ccdbd1038";
    
    self.textField.delegate = self;
    
    self.tempLabel.text = @"";
    self.descriptionLabel.text = @"";
    self.textField.text = @"Searching ...";
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
//    [self.locationManager requestLocation];
    
//    locationManager.delegate = self;
//    locationManager.distanceFilter = 50;
//    [locationManager requestWhenInUseAuthorization];
//    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - OpenWeather API Handler Methods

-(void)displayWeatherWithData:(NSDictionary *)weatherData {
    if (weatherData) {
        //    NSLog(@"%@", weatherData);
        self.cityID = [weatherData[@"id"] integerValue];
        
        // Set name of city in text field
        self.textField.text = weatherData[@"name"];
        
        // Set temperature label in Farenheight
        NSNumber *temperature = weatherData[@"main"][@"temp"];
        NSInteger temperatureAsInteger = [temperature integerValue];
        self.tempLabel.text = [NSString stringWithFormat:@"%li°F", temperatureAsInteger];
        
        // Set the description
        NSDictionary *weatherConditions = weatherData[@"weather"][0];
        NSString *description = [weatherConditions[@"description"] capitalizedString];
        self.descriptionLabel.text = [NSString stringWithFormat:@"%@", description];
        
        // Set the icon
        NSString *iconURLString = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",
                                   weatherConditions[@"icon"]];
        NSURL *iconURL = [NSURL URLWithString:iconURLString];
        NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
        self.iconImageView.image = [UIImage imageWithData:iconData];
        
        // Set the background image
        NSInteger forecastID = [weatherConditions[@"id"] integerValue];
        //    UIImage *splashImage = [self imageForForecastID:forecastID];
        UIImage *splashImage = [self savedImageForForecastID:forecastID];
        self.backgroundImageView.image = splashImage;
        //    self.imageView.image = [self imageForWeather:weatherConditions[@"main"]];
        
        //
        //
        //
    } else {
        self.textField.text = @"Specified location not found";
    }
}

// Refactor code into another method

-(NSDictionary *)weatherDataForCity:(NSString *)city {
    
    NSString *requestURLString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&units=imperial&APPID=%@", city, self.apiKey];
    
    NSURL *requestURL = [NSURL URLWithString:requestURLString];
    
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:requestURL];

    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:kNilOptions
                                                                     error:nil];
    return jsonDictionary;
}

-(NSDictionary *)weatherDataForCoordinates:(CLLocationCoordinate2D)coordinates {
    NSString *requestURLString = [NSString stringWithFormat:@"api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial&APPID=%@", coordinates.latitude, coordinates.longitude, self.apiKey];
    
    NSURL *requestURL = [NSURL URLWithString:requestURLString];
    
    //    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:requestURL];
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:kNilOptions
                                                                     error:nil];
    return jsonDictionary;
}

-(NSDictionary *)forecastDataForCurrentLocation {
    if (self.cityID) {
        NSString *requestURLString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?id=%lu&units=imperial&APPID=%@", self.cityID, self.apiKey];
        
        NSLog(@"%@", requestURLString);
        
        NSURL *requestURL = [NSURL URLWithString:requestURLString];
        NSData *jsonData = [NSData dataWithContentsOfURL:requestURL];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                       options:kNilOptions
                                                                         error:nil];
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
//        NSString *requestURLString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?id=%lu&units=imperial&APPID=%@", self.cityID, self.apiKey];
//        NSURL *url = [NSURL URLWithString:requestURLString];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        NSURLSession *session = [NSURLSession sharedSession];
//        
//        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            NSDictionary *weatherData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            
//            
//            
//            
//        }];
//        
//        
//        [dataTask resume];
    } else {
        return nil;
    }
}

#pragma mark - Unsplash API Handler Methods

-(UIImage *)imageForForecastID:(NSUInteger)forecastID {
    NSString *query = [self queryForForecastID:forecastID];
    
    NSString *urlString = [NSString stringWithFormat:@"https://source.unsplash.com/featured/?%@", query];
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    UIImage *image = [UIImage imageWithData:imageData];
    
    return image;
}

-(NSString *)queryForForecastID:(NSUInteger)forecastID {
    NSLog(@"%lu", forecastID);
    // Use dictionaries instead of switch case
    
    if (forecastID >= 200 && forecastID < 300) { // Thunderstorm
        return @"thunderstorm";
    } else if (forecastID >= 300 && forecastID < 400) { // Drizzle
        return @"drizzle";
    } else if (forecastID >= 500 && forecastID < 600) { // Rain
        return @"rain";
    } else if (forecastID >= 600 && forecastID < 700) { // Snow
        return @"snow";
    } else if (forecastID >= 700 && forecastID < 800) { // Atmosphere
        
        switch (forecastID) {
            case 701:
                return @"mist";
                break;
            case 711:
                return @"smoke";
                break;
            case 721:
                return @"haze,weather";
                break;
            case 731:
            case 751:
                return @"sand,weather";
                break;
            case 741:
                return @"fog";
                break;
            case 761:
                return @"dust,weather";
                break;
            case 771:
                return @"squalls,weather";
                break;
            case 781:
                return @"tornado";
                break;
            default:
                return @"atmosphere,weather";
                break;
        }
        
    } else if (forecastID == 800) { // Clear
        return @"clear,sky";
    } else if (forecastID > 800 && forecastID < 900) { // Clouds
        return @"cloudy,weather";
    } else if (forecastID >= 900 && forecastID < 950) { // Extreme
        
        switch (forecastID) {
            case 900:
                return @"tornado";
                break;
            case 901:
                return @"tropical,storm";
                break;
            case 902:
                return @"hurricane";
                break;
            case 903:
                return @"cold,weather";
                break;
            case 904:
                return @"hot,weather";
                break;
            case 905:
                return @"windy";
                break;
            case 906:
                return @"hail";
                break;
            default:
                return @"extreme,weather";
                break;
        }
        
    } else if (forecastID >= 950 && forecastID < 1000) { // Additional
        return @"gale";
    }
    return @"weather";
}

-(UIImage *)savedImageForForecastID:(NSUInteger)forecastID {
    if (forecastID >= 200 && forecastID < 300) { // Thunderstorm
        return [UIImage imageNamed:@"thunderstorm"];
    } else if (forecastID >= 300 && forecastID < 400) { // Drizzle
        return [UIImage imageNamed:@"drizzle"];
    } else if (forecastID >= 500 && forecastID < 600) { // Rain
        return [UIImage imageNamed:@"rain"];
    } else if (forecastID >= 600 && forecastID < 700) { // Snow
        return [UIImage imageNamed:@"snowing"];
    } else if (forecastID >= 700 && forecastID < 800) { // Atmosphere
        
        switch (forecastID) {
            case 701:
                return [UIImage imageNamed:@"mist"];
                break;
            case 711:
                return nil;
                break;
            case 721:
                return [UIImage imageNamed:@"haze"];
                break;
            case 731:
            case 751:
                return nil;
                break;
            case 741:
                return [UIImage imageNamed:@"fog"];
                break;
            case 761:
                return nil;
                break;
            case 771:
                return nil;
                break;
            case 781:
                return nil; //tornado
                break;
            default:
                return nil;
                break;
        }
        
    } else if (forecastID == 800) { // Clear
        return [UIImage imageNamed:@"sky"];
    } else if (forecastID > 800 && forecastID < 900) { // Clouds
        return [UIImage imageNamed:@"clouds"];
    } else if (forecastID >= 900 && forecastID < 950) { // Extreme
        return nil;
//        switch (forecastID) {
//            case 900:
//                return @"tornado";
//                break;
//            case 901:
//                return @"tropical,storm";
//                break;
//            case 902:
//                return @"hurricane";
//                break;
//            case 903:
//                return @"cold,weather";
//                break;
//            case 904:
//                return @"hot,weather";
//                break;
//            case 905:
//                return @"windy";
//                break;
//            case 906:
//                return @"hail";
//                break;
//            default:
//                return @"extreme,weather";
//                break;
//        }
        
    } else if (forecastID >= 950 && forecastID < 1000) { // Additional
        return nil;
    }
    return nil;
}



#pragma mark - UITextFieldDelegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.locationManager stopUpdatingLocation];
    NSString *query = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSDictionary *data = [self weatherDataForCity:query];
    [self displayWeatherWithData:data];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = locations.firstObject;
    NSDictionary *data = [self weatherDataForCoordinates:location.coordinate];
    [self displayWeatherWithData:data];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        self.textField.text = @"ERROR: Location Services Denied";
    } else if(error.code == kCLErrorLocationUnknown) {
        self.textField.text = @"ERROR: Location Unknown";
    }
    
}

#pragma mark - Miscellaneous Methods

-(BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - IBActions 

- (IBAction)forecastButtonTapped:(UIButton *)sender {
    NSDictionary *forecastDictionary = [self forecastDataForCurrentLocation];
}


@end
