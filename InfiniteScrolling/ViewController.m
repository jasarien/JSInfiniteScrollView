//
//  ViewController.m
//  InfiniteScrolling
//
//  Created by James Addyman on 12/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ViewController

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	_colours = [[NSArray alloc] initWithObjects:[UIColor redColor],
				[UIColor blueColor],
				[UIColor yellowColor],
				[UIColor greenColor],
				[UIColor purpleColor], nil];
	
	JSInfiniteScrollView *sv = [[[JSInfiniteScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)
															 dataSource:self
															   delegate:self] autorelease];
	[self.view addSubview:sv];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	[_colours release], _colours = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSUInteger)numberOfViewsInInfiniteScrollView:(JSInfiniteScrollView *)scrollView
{
	return 5;
}
- (UIView *)infiniteScrollView:(JSInfiniteScrollView*)scrollView viewForIndex:(NSUInteger)index
{
	UILabel *label = [[[UILabel alloc] initWithFrame:[scrollView bounds]] autorelease];
	[label setTextAlignment:UITextAlignmentCenter];
	[label setBackgroundColor:[_colours objectAtIndex:index]];
	[label setText:[NSString stringWithFormat:@"Test %d", index]];
	
	return label;
}

- (void)infiniteScrollView:(JSInfiniteScrollView *)scrollView didScrollToViewAtIndex:(NSUInteger)index
{
	
}

@end
