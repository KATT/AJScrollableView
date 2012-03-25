//
//  AJScrollableViewController.h
//  tvmatchen
//
//  Created by Alexander Johansson on 2011-08-12.
//  Copyright 2011 axj.nu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AJScrollableView.h"
@class AJScrollablePartialsView;
@protocol AJScrollablePartialsViewDelegate

-(NSInteger)scrollableViewItemWidth:(AJScrollablePartialsView *)scrollableView;

@end

@interface AJScrollablePartialsView : AJScrollableView {
    CGFloat _visible;
    CGFloat _itemWidth;
}
@property (nonatomic, assign) NSObject<AJScrollableViewDelegate,AJScrollablePartialsViewDelegate> *delegate;
@property (nonatomic, readonly) CGFloat numVisible;
@end
