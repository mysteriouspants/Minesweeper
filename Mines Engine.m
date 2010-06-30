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
// percentage of tiles allowed to be mines
CGFloat minesMin = 0.2000f;
CGFloat minesMax = 0.2000f;

@implementation Mines_Engine

@synthesize dg;
@synthesize gameStart;
@synthesize gameTimer;
@synthesize mines;

- (id)initWithApp:(mines_AppDelegate *)delegate {
	if(self=[super init])
		self.dg = delegate;
	return self;
}

- (void)receiveClickAtRow:(NSInteger)row
					  col:(NSInteger)col
			   rightClick:(BOOL)rightClick {
	NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
	if(self.gameStart == nil) {		// game has not yet started
		// start the timer
		for(size_t x = 0; x < 8; ++x)
			for(size_t y = 0; y < 8; ++y)
				putImageAtTile(BLANK_TILE, x, y);
		self.gameStart = [NSDate date];
		self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1
														  target:self
														selector:@selector(updateTimer)
														userInfo:nil
														 repeats:TRUE];
		// hide the text field
		[[self.dg textField] setStringValue:@""];
		if(mines)
			freeMinefield(mines);
		do {
			// generate random minefield
			mines = generateMinefield(minesMin,
									  minesMax);
			// if the clicked tile has a mine, regenerate it
			if(!HAS_MINE(mines,row,col))
				break;
			else
				NSLog(@"Minefield had a mine on starting position!");
		} while ( 0x0000 == 0x0000 ) ;
		// continue on to normal program flow
		
	}
	if(rightClick==NO) {
		if(HAS_MINE(mines,row,col)) {
			// you loose
			[self.dg.textField setStringValue:@"You Lose!"];
			[self.gameTimer invalidate];
			self.gameStart = nil;
																						// TODO: Expose whole field
			for(NSInteger j,i=0; i<MINES_ROWS; ++i)
				for(j=0; j<MINES_COLS; ++j) {
					if(HAS_MINE(mines,i,j)) {
						if(HAS_FLAG(mines,i,j))
							putImageAtTile(BOMB_FLAG_TILE, i, j);
						else if(HAS_QMARK(mines,i,j))
							putImageAtTile(BOMB_QMARK_TILE, i, j);
						else
							putImageAtTile(BOMB_TILE, i, j);
					}
				} 
			putImageAtTile(EXPLODED_BOMB, row, col);
		} else {
			// find how many mines are adjacent
			mines->minefield[row][col] += CLICKED;
			NSInteger num_mines = adjacentMines(mines,row,col);
			NSLog(@"adjacent mines: %ld",num_mines);
			putImageAtTile(NUM_0+num_mines,
						   row,
						   col);
			if(num_mines == 0) { // expand all the zeroes
				NSLog(@"Expanding all zeroes");
				for(NSInteger i=0; i<8; ++i)
					if(inBounds(mines,row+mines_dx[i],col+mines_dy[i]))
						if(!HAS_CLICKED(mines,row+mines_dx[i],col+mines_dy[i]))
							[self receiveClickAtRow:row+mines_dx[i]
												col:col+mines_dy[i]
										 rightClick:NO];
				
			}
		}
	} else {
		// cycle through flag/qmark/none
		if(HAS_QMARK(mines,row,col)) {
			mines->minefield[row][col] -= QMARKED;
			putImageAtTile(BLANK_TILE, row, col);
		} else if(HAS_FLAG(mines,row, col)) {
			mines->minefield[row][col] -= FLAGGED;
			mines->minefield[row][col] += QMARKED;
			putImageAtTile(QUESTION_MARK, row, col);
		} else {
			mines->minefield[row][col] += FLAGGED;
			putImageAtTile(FLAG_TILE, row, col);
		}
	}
	if(winConditions(mines)) {
		// the game is won
		[self.gameTimer invalidate];
		[self.dg.textField setStringValue:@"You win!"];
		self.gameStart = nil; // will cause the game to restart if a tile is clicked
	}
	[self.dg.window.contentView performSelectorOnMainThread:@selector(display)
												 withObject:nil
											  waitUntilDone:NO];
	logMinefield(mines);
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
	[self.dg.timer setStringValue:toPost];
	[self.dg.timer performSelectorOnMainThread:@selector(display)
									withObject:nil
								 waitUntilDone:NO];
	[pool0 release];
}

@end
