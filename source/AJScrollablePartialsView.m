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
-(void)reloadData {
    _itemWidth = [self.delegate scrollableViewItemWidth:self];
    _visible = ceil(self.scrollView.frame.size.width / _itemWidth);
    [super reloadData];
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


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self bufferAndPurgeViews];
    [self scrollToViewIndex:self.currentIndex];
    
    if ([self.delegate respondsToSelector:@selector(scrollableView:didScrolltoIndex:)]) {
        [self.delegate scrollableView:self didScrolltoIndex:self.currentIndex];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate; {
    if (!decelerate) {
        [self scrollToViewIndex: self.currentIndex];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self bufferAndPurgeViews];
}


-(CGPoint) centerPointForIndex:(int)index {
    CGFloat width = [self.delegate scrollableViewItemWidth:self];
    
    CGFloat x = width/2 + width * (float)index;
    CGFloat y = self.scrollView.contentSize.height/2;
    
    return CGPointMake(x,y);
    
}


-(void) purgeViews {
    
    int index = self.currentIndex;
    
    // Remove all non visible views in order to preserve memory
    
    // All before
    for (int i = 0; i < index - 1; i++) {
        [self purgeViewAtIndex:i];
    }
    
    // Buffer after
    for (int i = (index+_visible+1); i < self.numberOfViews; i++) {
        [self purgeViewAtIndex:i];
    }
    
    [self purgeFakeViews];
}


-(void) bufferAndPurgeViews {
    
    int index = self.currentIndex;
    
    
    [self addViewAtIndex:index];
    
    // Make sure that the previous view is loaded, if we're not at page 0 that is.
    if (index) {
        [self addViewAtIndex:index-1];
    }
    
    // Buffer after
    for (int i=index;i<(index+_visible+1);i++) {
        if (self.numberOfViews > i) {
            [self addViewAtIndex:i];
        }
    }
    
    [self purgeViews];
    
}



-(void)scrollToViewIndex:(int)index animated:(BOOL)animated {
    [self addViewAtIndex:index];
    [self addFakeViewsBetweenIndex:self.currentIndex and:index];
    
    
    
    CGFloat xOffset = (CGFloat)index*[self.delegate scrollableViewItemWidth: self];
    CGPoint offset = CGPointMake(xOffset, 0);
    
    [self.scrollView setContentOffset:offset animated:animated];
}
@end
