//
//  AJScrollableViewController.m
//  tvmatchen
//
//  Created by Alexander Johansson on 2011-08-12.
//  Copyright 2011 axj.nu. All rights reserved.
//

#import "AJScrollableView+Protected.h"
#import "AJScrollablePartialsView.h"

@implementation AJScrollablePartialsView

@synthesize 
	delegate=_delegate
;
-(void) purgeViews {
    // Purge only views that have tag > numberOfViews
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag-AJScrollableViewControllerViewTagOffset > self.numberOfViews) {
            [view removeFromSuperview];
        }
    }
}
-(void) bufferAndPurgeViews {
    [self purgeViews];
    // Add everything
    for (int i=0;i<self.numberOfViews;i++) {
        [self addViewAtIndex:i];
    }
}
-(void)reloadData {
    self.numberOfViews = [self.delegate scrollableViewCount:self];
    _itemWidth = [self.delegate scrollableViewItemWidth:self];
    _visible = ceil(self.scrollView.frame.size.width / _itemWidth);
    
    [self resizeScrollView];
    
    [self bufferAndPurgeViews];
}

-(int)currentIndex {    
    int index = round(self.scrollView.contentOffset.x / _itemWidth);
    if (index < 0) {
        index=0;
    }
    return index;
}


- (void) resizeScrollView {
    CGFloat width = self.numberOfViews * _itemWidth;
    if (self.numberOfViews % _visible != 0) {
        width += _itemWidth;
    }
    CGFloat height = self.scrollView.frame.size.height;
    CGSize scrollViewSize = CGSizeMake(width, height);
    
    [self.scrollView setContentSize:scrollViewSize];
    
}



-(CGPoint) centerPointForIndex:(int)index {
    CGFloat width = _itemWidth;
    
    CGFloat x = width/2 + width * (float)index;
    CGFloat y = self.scrollView.contentSize.height/2;
    
    return CGPointMake(x,y);
    
}

-(void)scrollToViewIndex:(int)index animated:(BOOL)animated {
    [self addViewAtIndex:index];
    [self addFakeViewsBetweenIndex:self.currentIndex and:index];
    
    
    
    CGFloat xOffset = (CGFloat)index*[self.delegate scrollableViewItemWidth: self];
    CGPoint offset = CGPointMake(xOffset, 0);
    if (CGPointEqualToPoint(offset, self.scrollView.contentOffset)) {
        [self.delegate scrollableView:self didScrolltoIndex:index];
        return;
    }
    
    [self.scrollView setContentOffset:offset animated:animated];
}

#pragma mark - scroll view delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollToViewIndex:self.currentIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate; {
    if (!decelerate) {
        [self scrollToViewIndex: self.currentIndex];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
}
@end
