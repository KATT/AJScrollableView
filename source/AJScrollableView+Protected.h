//
//  AJScrollableView+Protected.h
//  AJScrollableView
//
//  Created by Alexander Johansson on 2012-03-13.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AJScrollableView.h"


@interface AJScrollableView(Protected)

-(void)resizeScrollView;

-(CGPoint) centerPointForIndex:(int)index;

-(void)addViewAtIndex:(int)index;
- (UIView*) viewAtIndex: (int) index;


-(void)purgeFakeViews;
-(void) purgeViews;
-(void) purgeViewAtIndex:(int)index;

-(void) bufferAndPurgeViews;

-(void)addFakeViewsBetweenIndex:(int)fromIndex and:(int)toIndex;

@end