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

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.apiKey = @"e9da352d7560223033ad539ccdbd1038";
    
    self.textField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Weather API Handler Methods

-(void)displayWeatherForCity:(NSString *)city {
    
    NSDictionary *weatherData = [self weatherDataForCity:city];
    
    NSLog(@"%@", weatherData);

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

    NSString *iconURLString = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png",
                         weatherConditions[@"icon"]];
    NSURL *iconURL = [NSURL URLWithString:iconURLString];
    NSData *iconData = [NSData dataWithContentsOfURL:iconURL];
    self.iconImageView.image = [UIImage imageWithData:iconData];
    
//    self.imageView.image = [self imageForWeather:weatherConditions[@"main"]];
    
//
//
//
}

-(NSDictionary *)weatherDataForCity:(NSString *)city {
    
    NSString *requestURLString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&units=imperial&APPID=%@", city, self.apiKey];
    
    NSURL *requestURL = [NSURL URLWithString:requestURLString];
    
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSData *jsonData = [NSData dataWithContentsOfURL:requestURL];

    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:kNilOptions
                                                                     error:nil];
    NSLog(@"%@", jsonDictionary);
    return jsonDictionary;
}


#pragma mark - UITextFieldDelegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *query = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self displayWeatherForCity:query];
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Miscellaneous Methods

-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end
