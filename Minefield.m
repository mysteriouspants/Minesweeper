/*
 *  Minefield.c
 *  mines
 *
 *  Created by Chris Miller on 6/30/10.
 *  Copyright 2010 FSDEV. All rights reserved.
 *
 */

#include "Minefield.h"

BOOL randomSeeded=NO;
BOOL seedRandom() {
	if(!randomSeeded) {
		srandomdev();
		randomSeeded = YES;
	}
	return randomSeeded;
}

s_minefield* MakeMinefield(NSUInteger row,
						  NSUInteger col) {
	s_minefield * minefield = (s_minefield*)malloc(sizeof(s_minefield));
	minefield->minefield = malloc(row * sizeof(tileState *));
	for(NSInteger i=0; i<row; ++i)
		minefield->minefield[i] = malloc(col * sizeof(tileState));
	return minefield;
}

void freeMinefield(s_minefield *minefield) {
	free(minefield->minefield);
	free(minefield);
}

BOOL inBounds(s_minefield * mines,
			  NSInteger row,
			  NSInteger col) {
	if(((row < 0 || row > mines->x) || (col < 0 || col > mines->y)))
		return NO;
	else
		return YES;
}

NSUInteger adjacentMines(s_minefield *minefield,
						 NSInteger row,
						 NSInteger col) {
	NSUInteger i,mine_count = 0L;
	NSInteger drow,dcol;
	for(i=0; i<8; ++i) {
		drow = row + mines_dx[i];
		dcol = col + mines_dy[i];
		if(!inBounds(minefield,drow,dcol))
			continue;
		else if(HAS_MINE(minefield,drow,dcol))
			++mine_count;
	}
	return mine_count;
}

s_minefield* generateMinefield(CGFloat minesMin,
							   CGFloat minesMax) {
	// zero out the minefield
	NSInteger i,j,k; // evil non-C99 faggotry
	s_minefield * mines;
	mines = MakeMinefield(MINES_ROWS, MINES_COLS);
	for(i=0; i<MINES_ROWS; ++i)
		for(j=0; j<MINES_COLS; ++j)
			mines->minefield[i][j] = EMPTY;
	seedRandom();
	for(i=0; i<((NSInteger)(MINES_ROWS*MINES_COLS)*minesMax); ++i) {
		// grab a random coordinate
		j = random() % MINES_ROWS;
		k = random() % MINES_COLS;
		if(HAS_MINE(mines,j,k))
			continue; // we'll just skip this one
		else
			mines->minefield[j][k] = MINED;
	}
	// count the number of mines
	k =0;
	for(i=0; i<MINES_ROWS; ++i)
		for(j=0; j<MINES_COLS; ++j)
			if(HAS_MINE(mines,i,j))
				++k;
	if(k<((NSInteger)(MINES_ROWS*MINES_COLS)*minesMin))
		return generateMinefield(minesMin,
								 minesMax);
	else 
		return mines;
}

BOOL winConditions(s_minefield *mines) {
	NSInteger i,j;
	for(i=0; i<MINES_ROWS; ++i)
		for(j=0; j<MINES_COLS; ++j)
			if(!HAS_FLAG(mines,i,j)
			   &&
			   HAS_MINE(mines,i,j))
				return NO; // if a mine isn't flagged, return no
			else if(HAS_FLAG(mines,i,j)
					&&
					!HAS_MINE(mines,i,j))
				return NO; // if a unmined tile is flagged, return no
	return YES;
}

void logMinefield(s_minefield *mines) {
	NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
	NSMutableString * toLog = [[NSMutableString alloc] initWithString:@"\n"];
	NSUInteger i,j;
	for(i=0; i<MINES_ROWS; ++i) {
		[toLog appendFormat:@"%2d ",i];
		for(j=0; j<MINES_COLS; ++j) {
			// C = Clicked, M = Mined, {F = Flagged, ? = QMarked}
			
			if(HAS_CLICKED(mines, i, j))
				[toLog appendString:@"C"];
			else
				[toLog appendString:@" "];
			
			if(HAS_MINE(mines, i,j))
				[toLog appendString:@"M"];
			else
				[toLog appendString:@" "];
			
			if(HAS_FLAG(mines, i, j))
				[toLog appendString:@"F"];
			else if(HAS_QMARK(mines, i, j))
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
