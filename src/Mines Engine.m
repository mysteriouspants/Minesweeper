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
@synthesize gameStop;
@synthesize gameTimer;
@synthesize mines;
@synthesize blockedByScore;

- (id)initWithApp:(mines_AppDelegate *)delegate {
	if(self=[super init]) {
		self.dg = delegate;
		self.blockedByScore=NO;
	}
	return self;
}

- (void)receiveClickAtRow:(NSInteger)row
					  col:(NSInteger)col
			   rightClick:(BOOL)rightClick {
	if(blockedByScore==YES) {
		NSLog(@"Blocked by score");
		return;
	}
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
		// set the label for number of mines - number of flags
		[[self.dg textField] setStringValue:[NSString stringWithFormat:@"%ld",(countMines(mines)-countFlags(mines))]];
		// continue on to normal program flow
		
	}
	if(rightClick==NO) {
		if(HAS_MINE(mines,row,col)&&(!HAS_FLAG(mines,row,col)&&!HAS_QMARK(mines,row,col))) {
			// you loose
			[self.dg.textField setStringValue:@"You Lose! Click any tile to restart."];
			[self.gameTimer invalidate];
			self.gameStart = nil;
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
		} else if(HAS_MINE(mines,row,col)&&(HAS_FLAG(mines,row,col)||HAS_QMARK(mines,row,col))) {
			// do nothing
		} else if(!HAS_CLICKED(mines,row,col)) {
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
		if(HAS_CLICKED(mines,row,col)) {
			// do nothing
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
			[[self.dg textField] setStringValue:[NSString stringWithFormat:@"%ld",(countMines(mines)-countFlags(mines))]];
		}
	}
	if(winConditions(mines)) {
		// the game is won
		[self.gameTimer invalidate];
		self.blockedByScore = YES;
		self.gameStop = [NSDate date];
		[[self.dg textField] setStringValue:[NSString stringWithFormat:@"%ld",(countMines(mines)-countFlags(mines))]];
		for(NSInteger j,i=0; i<MINES_ROWS; ++i)
			for(j=0; j<MINES_COLS; ++j) {
				if(!HAS_MINE(mines,i,j)&&!HAS_CLICKED(mines,i,j)) {
					mines->minefield[i][j] += CLICKED;
					NSInteger num_mines = adjacentMines(mines,i,j);
					NSLog(@"adjacent mines: %ld",num_mines);
					putImageAtTile(NUM_0+num_mines,
								   i,
								   j);
				}
			} 
		// start the name dialog
		[NSApp beginSheet:self.dg.hiScoreWindow
		   modalForWindow:self.dg.window
			modalDelegate:self
		   didEndSelector:@selector(didEndSheet:returnCode:contextInfo:)
			  contextInfo:nil];
	}
	[self.dg.window.contentView performSelectorOnMainThread:@selector(display)
												 withObject:nil
											  waitUntilDone:NO];
	logMinefield(mines);
	[pool0 release];
}

- (void)didEndSheet:(NSWindow *)sheet
		 returnCode:(NSInteger)returnCode
		contextInfo:(void *)contextInfo {
    [sheet orderOut:self];
	NSManagedObjectContext *ctxt = [self.dg managedObjectContext];
	HiScore *score = [NSEntityDescription insertNewObjectForEntityForName:@"HiScore"
												   inManagedObjectContext:ctxt];
	score.gameStartDate = self.gameStart;
	score.gameStopDate = self.gameStop;
	score.playerName = [self.dg.hiScoresName stringValue];
	NSError *error;
	if(![ctxt save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
	} else {
		NSLog(@"Saved new highscore: %@", score);
		NSLog(@"Context now has %@", [ctxt registeredObjects]);
	}
	// broadcast that the scores have changed, just something unique and not in use by the system
	[[NSNotificationCenter defaultCenter] postNotificationName:@"FSDEV Mines high scores did change"
														object:self
													  userInfo:nil];
	self.gameStart = nil; // will cause the game to restart if a tile is clicked
	self.blockedByScore = NO;
	[self.dg.textField setStringValue:@"You win! Click to restart."];
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
