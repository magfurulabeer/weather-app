//
//  MainViewController.m
//  Weather App
//
//  Created by Magfurul Abeer on 3/1/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backgrounndImageView;
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

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate Methods


-(BOOL)prefersStatusBarHidden {
    return YES;
}

@end
