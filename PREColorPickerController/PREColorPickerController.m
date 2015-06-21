//
// PREColorPickerController.m
//
// Copyright (c) 2013-15 Paul Steinhilber (http://paulsteinhilber.de)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "PREColorPickerController.h"

@interface PREColorPickerController () {
    IBOutlet UIView* rView;
    
    IBOutlet UISlider* rSlider;
    IBOutlet UISlider* gSlider;
    IBOutlet UISlider* bSlider;
    
    IBOutlet UITextField* rField;
    IBOutlet UITextField* gField;
    IBOutlet UITextField* bField;
    
    IBOutlet UIImageView* imageView;
}
@end

@implementation PREColorPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:rView attribute:NSLayoutAttributeTop multiplier:1 constant:-8]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIColor* startColor = self.color;
    
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [startColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    rField.text = [NSString stringWithFormat:@"%.0f", red*255];
    gField.text = [NSString stringWithFormat:@"%.0f", green*255];
    bField.text = [NSString stringWithFormat:@"%.0f", blue*255];
    [rSlider setValue:red*255];
    [gSlider setValue:green*255];
    [bSlider setValue:blue*255];
    
    [self colorChanged];
    
    if (!self.navigationController) {
        NSAssert(false, @"PREColorPickerController assumes to be pushed onto a UINavigationController.");
    }
}

#pragma mark - 

- (IBAction)sliderMoved:(id)sender {
	[self hideKeyBoard:sender];
	
	rField.text = [NSString stringWithFormat:@"%.0f", rSlider.value];
	gField.text = [NSString stringWithFormat:@"%.0f", gSlider.value];
	bField.text = [NSString stringWithFormat:@"%.0f", bSlider.value];
	
	[self colorChanged];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	string = [textField.text stringByReplacingCharactersInRange:range withString:string];
	if ([string intValue] > 255) {
		[self performSelector:@selector(hideKeyBoard:) withObject:textField afterDelay:0.1];
		return NO;
	} else if (textField == rField) {
		[rSlider setValue:[string intValue] animated:YES];
	} else if (textField == gField) {
		[gSlider setValue:[string intValue] animated:YES];
	} else if (textField == bField) {
		[bSlider setValue:[string intValue] animated:YES];
	}
	
	[self colorChanged];
	
	if ([string length] == 3) {
		[self performSelector:@selector(hideKeyBoard:) withObject:textField afterDelay:0.1];
	} else {
		[self performSelector:@selector(hideKeyBoard:) withObject:textField afterDelay:2];
	}
	return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
	[self performSelector:@selector(hideKeyBoard:) withObject:textField afterDelay:5];
}

- (void)hideKeyBoard:(id)sender {
	if ([rField isFirstResponder])
		[rField resignFirstResponder];
	if ([gField isFirstResponder])
		[gField resignFirstResponder];
	if ([bField isFirstResponder])
		[bField resignFirstResponder];
}

- (void)colorChanged {
	int red = rSlider.value;
	int gre = gSlider.value;
	int blu = bSlider.value;
    
	self.color = [UIColor colorWithRed:red/255. green:gre/255. blue:blu/255. alpha:1];
	[imageView setBackgroundColor:self.color];
    
    if (self.changeNavigationBarTintColor) {
        [self.navigationController.navigationBar setTintColor:self.color];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorPicker:didFinishPickingColor:withRed:green:blue:)]) {
        [self.delegate colorPicker:self didFinishPickingColor:self.color withRed:red green:gre blue:blu];
    } else {
        NSLog(@"[PREColorPickerController] Warning! Delegate method missing.");
    }
}

@end
