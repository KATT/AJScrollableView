//
//  AJViewController.m
//  AJScrollableView
//
//  Created by Alexander Johansson on 2012-03-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AJViewController.h"

@interface AJViewController ()

@end

@implementation AJViewController

@synthesize 
	scrollView=_scrollView
,	scrollableViewController=_scrollableViewController
;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.scrollableViewController = [[AJScrollablePartialsView alloc] initWithScrollView:self.scrollView andDelegate:self];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
#pragma mark - AJScrollableViewDelegate
-(NSInteger)scrollableViewItemSpacing:(AJScrollableView *)scrollableView {
    return 0;
}
-(NSInteger)scrollableViewItemWidth:(AJScrollableView *)scrollableView {
    return 100;
}
- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (UIColor *) randomColor {
    CGFloat red =  [self randomFloatBetween:0 and:1];
    CGFloat blue = [self randomFloatBetween:0 and:1];
    CGFloat green = [self randomFloatBetween:0 and:1];
    DLog(@"red: %f", red);
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

// Get view for index 
-(UIView*)scrollableView: (AJScrollableView*)scrollableView viewForIndex:(int)index {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    
    view.backgroundColor=[self randomColor];
    
	UILabel *label = nil;
	
    label = [[UILabel alloc] initWithFrame:view.bounds];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [label.font fontWithSize:50];
    [view addSubview:label];
	
    //set label
	label.text = [NSString stringWithFormat:@"%d", index];
    
    return view;
}

// Number of views that the scrollableView contains
-(int)scrollableViewCount: (AJScrollableView*)scrollableView {
    return 1000;
}

@end
