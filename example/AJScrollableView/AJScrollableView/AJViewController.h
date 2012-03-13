//
//  AJViewController.h
//  AJScrollableView
//
//  Created by Alexander Johansson on 2012-03-10.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJScrollablePartialsView.h"

@interface AJViewController : UIViewController<AJScrollableViewDelegate, AJScrollablePartialsViewDelegate>

@property	(nonatomic, retain)					AJScrollablePartialsView	*scrollableViewController;
@property	(nonatomic, retain)		IBOutlet 	UIScrollView		*scrollView;

@end
