//
//  ViewController.m
//  PREColorPickerSample
//
//  Created by Paul Steinhilber on 07.06.2015.
//  Copyright (c) 2015 Paul Steinhilber. All rights reserved.
//

#import "ViewController.h"
#import "PREColorPickerController.h"

@interface ViewController ()
@property (nonatomic,retain) UIColor* color;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.color = [UIColor colorWithRed:80./255. green:160./255. blue:160./255. alpha:1];
    [self.view setBackgroundColor:self.color];
    
    self.title = @"PREColorPicker";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickColor:(id)sender {
    PREColorPickerController* colorPicker = [PREColorPickerController new];
    colorPicker.color = self.color;
    colorPicker.delegate = self;
    colorPicker.changeNavigationBarTintColor = YES;
    [self.navigationController pushViewController:colorPicker animated:YES];
}

#pragma mark - PREColorPickerDelegate

- (void)colorPicker:(PREColorPickerController *)colorPicker didFinishPickingColor:(UIColor *)color withRed:(int)red green:(int)green blue:(int)blue {
    [self.view setBackgroundColor:color];
    self.color = color;
}

@end
