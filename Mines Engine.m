//
//  Mines Engine.m
//  mines
//
//  Created by Chris Miller on 6/23/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import "Mines Engine.h"
#import "mines_AppDelegate.h"

#define MINES_ROWS 8
#define MINES_COLS 8
BOOL minefield[MINES_ROWS][MINES_COLS];
BOOL randomSeeded=NO;
// percentage of tiles allowed to be mines
CGFloat minesMin = 0.1500f;
CGFloat minesMax = 0.4500f;

@implementation Mines_Engine

@synthesize dg;
@synthesize gameStart;
@synthesize gameTimer;

BOOL seedRandom() {
	if(!randomSeeded) {
		
		randomSeeded = YES;
	}
	return randomSeeded;
}

void generateMinefield() {
	// zero out the minefield
	NSUInteger i,j; // evil non-C99 faggotry
	for(i=0; i<MINES_ROWS; ++i)
		for(j=0; j<MINES_COLS; ++j)
			minefield[i][j] = NO;
	for(i=0; i<((NSInteger)(MINES_ROWS*MINES_COLS)*minesMax); ++i) {
		
	}
}

- (id)initWithApp:(mines_AppDelegate *)delegate {
	if(self=[super init])
		self.dg = delegate;
	return self;
}

- (void)receiveClickAtRow:(NSInteger)row
					  col:(NSInteger)col {
	NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
	if(self.gameStart == nil) {		// game has not yet started
		// start the timer
		self.gameStart = [NSDate date];
		self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1
														  target:self
														selector:@selector(updateTimer)
														userInfo:nil
														 repeats:TRUE];
		// hide the text field
		[[self.dg textField] setStringValue:@""];
		// generate random minefield
		// if the clicked tile has a mine, regenerate it
		// continue on to normal program flow
	}
	[pool0 release];
}
						  
- (void)updateTimer {
	NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
	// determine seconds between now and gameStart
	NSTimeInterval seconds = [[NSDate date] timeIntervalSinceDate:self.gameStart];
	NSInteger minutes = ((NSInteger)((CGFloat)seconds/60.0f));
	NSString * toPost = [NSString stringWithFormat:@"%02d M %02d S",
						 minutes,
						 ((NSInteger)seconds) - (minutes*60)];
	NSLog(@"%@",toPost);
	[self.dg.timer setStringValue:toPost];
	[self.dg.timer performSelectorOnMainThread:@selector(display)
									withObject:nil
								 waitUntilDone:NO];
	[pool0 release];
}

@end
