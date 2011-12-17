//
//  JSInfiniteScrollView.m
//  JSInfiniteScrolling
//
//  Created by James Addyman on 17/12/2011.
//  Copyright (c) 2011 JamSoft. All rights reserved.
//

#import "JSInfiniteScrollView.h"

@interface JSInfiniteScrollView ()

- (NSInteger)previousIndex;
- (NSInteger)nextIndex;
- (void)setupScrollView;
- (void)layoutScrollView;

@end

@implementation JSInfiniteScrollView

@synthesize delegate = _delegate;
@synthesize dataSource = _dataSource;

- (id)initWithFrame:(CGRect)frame dataSource:(id <InfiniteScrollViewDataSource>)dataSource delegate:(id <InfiniteScrollViewDelegate>)delegate
{
	if ((self = [super initWithFrame:frame]))
	{
		[self setBackgroundColor:[UIColor whiteColor]];
		
		self.dataSource = dataSource;
		self.delegate = delegate;
		_currentIndex = 0;
		
		_scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
		[_scrollView setDelegate:self];
		[_scrollView setPagingEnabled:YES];
		[_scrollView setShowsVerticalScrollIndicator:NO];
		[_scrollView setShowsHorizontalScrollIndicator:NO];
		[self addSubview:_scrollView];
		
		[self reloadData];
	}
	
	return self;
}

- (void)dealloc
{
	self.delegate = nil;
	self.dataSource = nil;
	[super dealloc];
}

- (NSInteger)previousIndex
{
	NSInteger previousIndex = _currentIndex - 1;
	if (previousIndex < 0)
	{
		previousIndex = _numberOfViews - 1;
	}
	
	return previousIndex;
}

- (NSInteger)nextIndex
{
	NSInteger nextIndex = _currentIndex + 1;
	if (nextIndex > _numberOfViews - 1)
	{
		nextIndex = 0;
	}
	
	return nextIndex;
}

- (void)setupScrollView
{
	_currentIndex = 0;
	_numberOfViews = [self.dataSource numberOfViewsInInfiniteScrollView:self];
	
	if (_numberOfViews > 0)
	{
		_prevView = [self.dataSource infiniteScrollView:self viewForIndex:[self previousIndex]];
		[_scrollView addSubview:_prevView];
		
		_currentView = [self.dataSource infiniteScrollView:self viewForIndex:_currentIndex];
		[_scrollView addSubview:_currentView];
		
		_nextView = [self.dataSource infiniteScrollView:self viewForIndex:[self nextIndex]];
		[_scrollView addSubview:_nextView];
		
		[self layoutScrollView];
	}
}

- (void)layoutScrollView
{
	CGRect viewFrame = [_prevView frame];
	viewFrame.origin.x = 0;
	[_prevView setFrame:viewFrame];
	
	viewFrame = [_currentView frame];
	viewFrame.origin.x = [self frame].size.width;
	[_currentView setFrame:viewFrame];
	
	viewFrame = [_nextView frame];
	viewFrame.origin.x = [self frame].size.width * 2;
	[_nextView setFrame:viewFrame];
	
	[_scrollView setContentSize:CGSizeMake([self frame].size.width * 3, [self frame].size.height)];
	[_scrollView setContentOffset:CGPointMake([self frame].size.width, 0)];
	_currentOffset = [_scrollView contentOffset];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	if ([_scrollView contentOffset].x < _currentOffset.x)
	{
		_currentIndex = _currentIndex - 1;
		if (_currentIndex < 0)
		{
			_currentIndex = _numberOfViews - 1;
		}
		
		[_nextView removeFromSuperview];
		_nextView = _currentView;
		_currentView = _prevView;
		_prevView = [self.dataSource infiniteScrollView:self viewForIndex:[self previousIndex]];
		[_scrollView addSubview:_prevView];
		
		[self layoutScrollView];
	}
	else if ([_scrollView contentOffset].x > _currentOffset.x)
	{
		_currentIndex = _currentIndex + 1;
		if (_currentIndex > _numberOfViews - 1)
		{
			_currentIndex = 0;
		}
		
		[_prevView removeFromSuperview];
		_prevView = _currentView;
		_currentView = _nextView;
		_nextView = [self.dataSource infiniteScrollView:self viewForIndex:[self nextIndex]];
		[_scrollView addSubview:_nextView];
		
		[self layoutScrollView];		
	}
}

- (void)reloadData
{
	[_prevView removeFromSuperview];
	[_currentView removeFromSuperview];
	[_nextView removeFromSuperview];
	
	[self setupScrollView];
}

@end
