//
//  AJScrollableViewController.m
//  tvmatchen
//
//  Created by Alexander Johansson on 2011-08-12.
//  Copyright 2011 axj.nu. All rights reserved.
//

#import <QuartzCore/CoreAnimation.h>
#import "AJScrollableView.h"
#import "AJScrollableView+Protected.h"
@implementation AJScrollableView



@synthesize 
    scrollView=_scrollView,
    delegate=_delegate,
    numberOfViews=_numberOfViews
;

- (id) initWithScrollView:(UIScrollView *)scrollView andDelegate:(NSObject<AJScrollableViewDelegate> *)delegate {
    
    
    self = [self init];
    if (self) {
        self.scrollView=scrollView;
        self.scrollView.delegate=self;
        self.delegate=delegate;
        
        [self reloadData];
    }
    return self;
}

#pragma mark - Custom getters
-(int)currentIndex {
    
    int index = round(self.scrollView.contentOffset.x / self.scrollView.bounds.size.width);
    return index;
}

-(UIView*)currentView {
    return [self viewAtIndex:self.currentIndex];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self bufferAndPurgeViews];
    
    if ([self.delegate respondsToSelector:@selector(scrollableView:didBeginScrollFromIndex:)]) {
        [self.delegate scrollableView:self didBeginScrollFromIndex:self.currentIndex];
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self bufferAndPurgeViews];
    
    if ([self.delegate respondsToSelector:@selector(scrollableView:didScrolltoIndex:)]) {
        [self.delegate scrollableView:self didScrolltoIndex:self.currentIndex];
    }
    
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    [self bufferAndPurgeViews];
    
    if ([self.delegate respondsToSelector:@selector(scrollableView:didScrolltoIndex:)]) {
        [self.delegate scrollableView:self didScrolltoIndex:self.currentIndex];
    }
}

#pragma mark - protected methods

-(CGPoint) centerPointForIndex:(int)index {
    CGFloat x = self.scrollView.center.x + self.scrollView.frame.size.width * (float)index;
    CGFloat y = self.scrollView.contentSize.height/2;
    
    return CGPointMake(x,y);
    
}


-(void)purgeFakeViews {
    
    for (UIView *view in [self.scrollView subviews]) {
        
        if (view.tag == AJScrollableViewControllerFakeViewsTag) {
            [view removeFromSuperview];
        }
    }
}
- (void)purgeViewAtIndex:(int)index {
    [[self viewAtIndex:index] removeFromSuperview];
    
    
}

-(void) purgeViews {
    
    int index = self.currentIndex;
    
    // Remove all other views to preserve memory.
    for (int i = 0; i < index - 1; i++) {
        [self purgeViewAtIndex:i];
    }
    for (int i = index + 2; i < self.numberOfViews; i++) {
        [self purgeViewAtIndex:i];
    }
    
    [self purgeFakeViews];
}



-(void) bufferAndPurgeViews {
    
    int index = self.currentIndex;
    [self addViewAtIndex:index];
    // Make sure that the next image is loaded
    if (self.numberOfViews > index+1) {
        [self addViewAtIndex:index+1];
    }
    // Make sure that the previous view is loaded, if we're not at page 0 that is.
    if (index) {
        [self addViewAtIndex:index-1];
    }
    
    [self purgeViews];
    
}


- (UIView*) viewAtIndex: (int) index {
    UIView *view = nil;
    for (view in [self.scrollView subviews]) {
        if (view.tag == index+AJScrollableViewControllerViewTagOffset) {
            return view;
        }
    }
    return view;
}


-(void)addViewAtIndex:(int)index {
    
    // See if event isn't already added
    
    if ([self viewAtIndex:index]) {
        // page %d already loaded
        return;
    }
    UIView *pageView = [self.delegate scrollableView:self viewForIndex:index];
    
    pageView.center = [self centerPointForIndex:index];
    
    pageView.tag = index+AJScrollableViewControllerViewTagOffset;
    
    [self.scrollView insertSubview:pageView atIndex:0];
    
    
}


-(void)addFakeViewsBetweenIndex:(int)fromIndex and:(int)toIndex {
    // Get the first DayView loaded
    if (fromIndex > toIndex) {
        int temp = fromIndex;
        fromIndex = toIndex;
        toIndex=temp;
    }
    
    // AddFakeViews from %d to %d", fromPage, toPage
    
    
    UIView *cloneView = nil;
    
    // Find first view added
    for (UIView *view in [self.scrollView subviews]) {
        // ignore other fake views
        if (view.tag == AJScrollableViewControllerFakeViewsTag)
            continue;
        
        // ignore if not a that we've added
        if (view.tag < AJScrollableViewControllerViewTagOffset ||
            view.tag >= AJScrollableViewControllerViewTagOffset+self.numberOfViews)
            continue;
        
        // ask delegate if ok to use as base for fake views
        if ([self.delegate respondsToSelector:@selector(scrollableView:shouldUseViewAsFakeView:index:)]) {
            
            if ([self.delegate scrollableView:self shouldUseViewAsFakeView:view index:view.tag-AJScrollableViewControllerViewTagOffset ]) {
                cloneView = view;
                break;
            }
        } else {
            cloneView = view;
            break;
            
        }
        
    }
    
    if (cloneView == nil) {
        return;
    }
    
    UIGraphicsBeginImageContext(cloneView.bounds.size);
    [cloneView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    for (int page=fromIndex;page<toIndex;page++) {
    	if ([self viewAtIndex:page] != nil) {
            continue;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        
	    imageView.center = [self centerPointForIndex:page];
        
	    imageView.tag = AJScrollableViewControllerFakeViewsTag;
    	[self.scrollView insertSubview:imageView atIndex:0];
        
    }
}


- (void) resizeScrollView {
    CGFloat width = self.numberOfViews * self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    CGSize scrollViewSize = CGSizeMake(width, height);
    
    [self.scrollView setContentSize:scrollViewSize];
    
}

#pragma mark - Methods
-(void)scrollToViewIndex:(int)index {
    [self scrollToViewIndex:index animated:YES];
    
}

-(void)scrollToViewIndex:(int)index animated:(BOOL)animated {
    [self addViewAtIndex:index];
    [self addFakeViewsBetweenIndex:self.currentIndex and:index];
    
    
    
    CGFloat xOffset = (CGFloat)index*self.scrollView.bounds.size.width;
    CGPoint offset = CGPointMake(xOffset, 0);
    
    [self.scrollView setContentOffset:offset animated:animated];
    
    
}


-(void)reloadData {
    // Resize scrollView
    self.numberOfViews = [self.delegate scrollableViewCount:self];
    
    
    [self resizeScrollView];
    
    
    
    // Loop through views
    for (UIView *view in [self.scrollView subviews]) {
        // See if the view is reloadable
        if ([view respondsToSelector:@selector(reloadData)]) {
            [view performSelector:@selector(reloadData)];
            continue;
        }
        
        // Otherwise, ask the delegate if we can remove the view
        if ([self.delegate respondsToSelector:@selector(scrollableView:shouldRemoveView:atIndex:)]) {
            if ([self.delegate scrollableView:self shouldRemoveView:view atIndex:view.tag-AJScrollableViewControllerViewTagOffset]) {
                
                [view removeFromSuperview];
            }
        }
    }
    
    
    [self bufferAndPurgeViews];
    
}

@end
