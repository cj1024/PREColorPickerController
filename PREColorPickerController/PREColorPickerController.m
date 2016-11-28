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
    IBOutlet UIView* gView;
    IBOutlet UIView* bView;
    IBOutlet UIView* aView;
    
    IBOutlet UISlider* rSlider;
    IBOutlet UISlider* gSlider;
    IBOutlet UISlider* bSlider;
    IBOutlet UISlider* aSlider;
    
    IBOutlet UITextField* rField;
    IBOutlet UITextField* gField;
    IBOutlet UITextField* bField;
    IBOutlet UITextField* aField;
    
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
    aField.text = [NSString stringWithFormat:@"%.0f", alpha*255];
    [rSlider setValue:red*255];
    [gSlider setValue:green*255];
    [bSlider setValue:blue*255];
    [aSlider setValue:alpha*255];
    
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
    aField.text = [NSString stringWithFormat:@"%.0f", aSlider.value];
    
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
    } else if (textField == aField) {
        [aSlider setValue:[string intValue] animated:YES];
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
    if ([aField isFirstResponder])
        [aField resignFirstResponder];
}

- (void)colorChanged {
	CGFloat red = rSlider.value;
	CGFloat gre = gSlider.value;
	CGFloat blu = bSlider.value;
    CGFloat alp = aSlider.value;
    
    rSlider.minimumTrackTintColor = [UIColor colorWithRed:red/255. green:gre/255. blue:blu/255. alpha:alp/255.];
    rSlider.maximumTrackTintColor = [UIColor colorWithRed:1 green:gre/255. blue:blu/255. alpha:alp/255.];
    gSlider.minimumTrackTintColor = [UIColor colorWithRed:red/255. green:gre/255. blue:blu/255. alpha:alp/255.];
    gSlider.maximumTrackTintColor = [UIColor colorWithRed:red/255. green:1 blue:blu/255. alpha:alp/255.];
    bSlider.minimumTrackTintColor = [UIColor colorWithRed:red/255. green:gre/255. blue:blu/255. alpha:alp/255.];
    bSlider.maximumTrackTintColor = [UIColor colorWithRed:red/255. green:gre/255. blue:1 alpha:alp/255.];
    aSlider.minimumTrackTintColor = [UIColor colorWithRed:red/255. green:gre/255. blue:blu/255. alpha:alp/255.];
    aSlider.maximumTrackTintColor = [UIColor colorWithRed:red/255. green:gre/255. blue:blu/255. alpha:1];
    
	self.color = [UIColor colorWithRed:red/255. green:gre/255. blue:blu/255. alpha:alp/255.];
	[imageView setBackgroundColor:self.color];
    
    if (self.changeNavigationBarTintColor) {
        [self.navigationController.navigationBar setTintColor:self.color];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorPicker:didFinishPickingColor:withRed:green:blue:alpha:)]) {
        [self.delegate colorPicker:self didFinishPickingColor:self.color withRed:red green:gre blue:blu alpha:alp];
    } else {
        NSLog(@"[PREColorPickerController] Warning! Delegate method missing.");
    }
}

@end
