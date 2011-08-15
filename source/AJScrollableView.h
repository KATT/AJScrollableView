//
//  AJScrollableViewController.h
//  tvmatchen
//
//  Created by Alexander Johansson on 2011-08-12.
//  Copyright 2011 axj.nu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AJScrollableView;
@protocol AJScrollableViewDelegate

// Get view for index 
-(UIView*)scrollableView: (AJScrollableView*)scrollableView viewForIndex:(int)index;

// Number of views that the scrollableView contains
-(int)scrollableViewCount: (AJScrollableView*)scrollableView;

@optional

// Called when reloading scrollableView
-(BOOL)scrollableView: (AJScrollableView*)scrollableView shouldRemoveView: (UIView*)view atIndex:(int)index;


-(void)scrollableView: (AJScrollableView*)scrollableView didScrolltoIndex:(int)index;
-(void)scrollableView: (AJScrollableView*)scrollableView didBeginScrollFromIndex:(int)index;


-(BOOL)scrollableView: (AJScrollableView*)scrollableView shouldUseViewAsFakeView: (UIView*)view index:(int)index;
@end

@interface AJScrollableView : NSObject<UIScrollViewDelegate>

-(id)initWithScrollView: (UIScrollView*)scrollView andDelegate:(id<AJScrollableViewDelegate>) delegate;

-(void)reloadData;

@property (nonatomic,retain) UIScrollView *scrollView;

@property (nonatomic) int numberOfViews;
@property (nonatomic, readonly) int currentIndex;
@property (nonatomic, readonly) UIView *currentView;

@property (nonatomic, assign) NSObject<AJScrollableViewDelegate> *delegate;


-(void)scrollToViewIndex:(int)index;
-(void)scrollToViewIndex:(int)index animated:(BOOL)animated;



@end
