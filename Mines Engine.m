//
//  Mines Engine.m
//  mines
//
//  Created by Chris Miller on 6/23/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import "Mines Engine.h"
#import "mines_AppDelegate.h"

typedef enum {
	EMPTY=  0x0000,
	CLICKED=0x0001,
	MINED=  0x0002,
	FLAGGED=0x0004,
	QMARKED=0x0008
} tileState;

NSInteger dx[8] = { -1, +0, +1, +1, +1, +0, -1, -1 };
NSInteger dy[8] = { +1, +1, +1, +0, -1, -1, -1, +0 };

#define MINES_ROWS 8
#define MINES_COLS 8
#define HAS_MINE(row, col) ((minefield[row][col] & MINED) - MINED == 0)
#define HAS_FLAG(row, col) ((minefield[row][col] & FLAGGED) - FLAGGED == 0)
#define HAS_QMARK(row, col) ((minefield[row][col] & QMARKED) - QMARKED == 0)
#define HAS_CLICKED(row, col) ((minefield[row][col] & CLICKED) - CLICKED == 0)
tileState minefield[MINES_ROWS][MINES_COLS];
BOOL randomSeeded=NO;
// percentage of tiles allowed to be mines
CGFloat minesMin = 0.1500f;
CGFloat minesMax = 0.4500f;

@implementation Mines_Engine

@synthesize dg;
@synthesize gameStart;
@synthesize gameTimer;

void logMinefield() {
	NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
	NSMutableString * toLog = [[NSMutableString alloc] initWithString:@"\n"];
	NSUInteger i,j;
	for(i=0; i<MINES_ROWS; ++i) {
		[toLog appendFormat:@"%2d ",i];
		for(j=0; j<MINES_COLS; ++j) {
			// C = Clicked, M = Mined, {F = Flagged, ? = QMarked}
			
			if((minefield[i][j] & CLICKED) - CLICKED == 0)
				[toLog appendString:@"C"];
			else
				[toLog appendString:@" "];
			
			if(HAS_MINE(i,j))
				[toLog appendString:@"M"];
			else
				[toLog appendString:@" "];
			
			if((minefield[i][j] & FLAGGED) - FLAGGED == 0)
				[toLog appendString:@"F"];
			else if((minefield[i][j] & QMARKED) - QMARKED == 0)
				[toLog appendString:@"?"];
			else
				[toLog appendString:@" "];
			
			[toLog appendString:@" "];
		}
		[toLog appendString:@"\n"];
	}
	NSLog(@"%@",toLog);
	[pool0 release];
}

BOOL seedRandom() {
	if(!randomSeeded) {
		srandomdev();
		randomSeeded = YES;
	}
	return randomSeeded;
}

void generateMinefield() {
	// zero out the minefield
	NSInteger i,j,k; // evil non-C99 faggotry
	for(i=0; i<MINES_ROWS; ++i)
		for(j=0; j<MINES_COLS; ++j)
			minefield[i][j] = EMPTY;
	seedRandom();
	for(i=0; i<((NSInteger)(MINES_ROWS*MINES_COLS)*minesMax); ++i) {
		// grab a random coordinate
		j = random() % MINES_ROWS;
		k = random() % MINES_COLS;
		if(HAS_MINE(j,k))
			continue; // we'll just skip this one
		else
			minefield[j][k] = MINED;
	}
	// count the number of mines
	k =0;
	for(i=0; i<MINES_ROWS; ++i)
		for(j=0; j<MINES_COLS; ++j)
			if(HAS_MINE(i,j))
				++k;
	if(k<((NSInteger)(MINES_ROWS*MINES_COLS)*minesMin))
		generateMinefield();
}

BOOL winConditions() {
	NSInteger i,j;
	for(i=0; i<MINES_ROWS; ++i)
		for(j=0; j<MINES_COLS; ++j)
			if((minefield[i][j] & FLAGGED) - FLAGGED != 0
								&&
			   HAS_MINE(i,j))
				return NO; // if a mine isn't flagged, return no
			else if((minefield[i][j] & FLAGGED) - FLAGGED == 0
								&&
					!HAS_MINE(i,j))
				return NO; // if a unmined tile is flagged, return no
	return YES;
}

NSUInteger adjacentMines(NSUInteger row, NSUInteger col) {
	NSUInteger i,mine_count = 0L;
	NSInteger drow,dcol;
	for(i=0; i<8; ++i) {
		drow = row + dx[i];
		dcol = col + dy[i];
		if((drow <0 || drow > 7)
					||
		   (dcol <0 || dcol > 7))
			continue;
		else
			if(HAS_MINE(drow,dcol))
				++mine_count;
	}
	return mine_count;
}

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
		do {
			// generate random minefield
			generateMinefield();
			// if the clicked tile has a mine, regenerate it
			if(!HAS_MINE(row,col))
				break;
			else
				NSLog(@"Minefield had a mine on starting position!");
		} while ( 0x0000 == 0x0000 ) ;
		// continue on to normal program flow
		
	}
	if(rightClick==NO) {
		if((minefield[row][col] & MINED) - MINED == 0) {
			// you loose
			[self.dg.textField setStringValue:@"You Loose!"];
			[self.gameTimer invalidate];
			self.gameStart = nil;
																						// TODO: Expose whole field
			for(NSInteger j,i=0; i<MINES_ROWS; ++i)
				for(j=0; j<MINES_COLS; ++j) {
					if(HAS_MINE(i,j)) {
						if(HAS_FLAG(i,j))
							putImageAtTile(BOMB_FLAG_TILE, i, j);
						else if(HAS_QMARK(i,j))
							putImageAtTile(BOMB_QMARK_TILE, i, j);
						else
							putImageAtTile(BOMB_TILE, i, j);
					}
				} 
			putImageAtTile(EXPLODED_BOMB, row, col);
		} else {
			// find how many mines are adjacent
			minefield[row][col] += CLICKED;
			NSInteger num_mines = adjacentMines(row,col);
			NSLog(@"adjacent mines: %ld",num_mines);
			putImageAtTile(NUM_0+num_mines,
						   row,
						   col);
		}
	} else {
		// cycle through flag/qmark/none
		if(HAS_QMARK(row,col)) {
			minefield[row][col] -= QMARKED;
			putImageAtTile(BLANK_TILE, row, col);
		} else if(HAS_FLAG(row, col)) {
			minefield[row][col] -= FLAGGED;
			minefield[row][col] += QMARKED;
			putImageAtTile(QUESTION_MARK, row, col);
		} else {
			minefield[row][col] += FLAGGED;
			putImageAtTile(FLAG_TILE, row, col);
		}
	}
	if(winConditions()) {
		// the game is won
		[self.gameTimer invalidate];
		[self.dg.textField setStringValue:@"You win!"];
		self.gameStart = nil; // will cause the game to restart if a tile is clicked
	}
	[self.dg.window.contentView performSelectorOnMainThread:@selector(display)
												 withObject:nil
											  waitUntilDone:NO];
	logMinefield();
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
