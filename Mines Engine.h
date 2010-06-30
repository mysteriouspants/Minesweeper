//
//  Mines Engine.h
//  mines
//
//  Created by Chris Miller on 6/23/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Minefield.h"

#include <stdlib.h>

@class mines_AppDelegate;

@interface Mines_Engine : NSObject {
	__weak mines_AppDelegate * dg;
	NSDate * gameStart;
	NSTimer * gameTimer;
	s_minefield * mines;
}

@property(readwrite,assign) mines_AppDelegate * dg;
@property(readwrite,retain) NSDate * gameStart;
@property(readwrite,retain) NSTimer * gameTimer;
@property(readwrite,assign) s_minefield * mines;

- (id)initWithApp:(mines_AppDelegate *)delegate;

- (void)receiveClickAtRow:(NSInteger)row
					  col:(NSInteger)col
			   rightClick:(BOOL)rightClick;

@end