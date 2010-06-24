//
//  Mines Engine.m
//  mines
//
//  Created by Chris Miller on 6/23/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import "Mines Engine.h"
#import "mines_AppDelegate.h"

@implementation Mines_Engine

@synthesize dg;
@synthesize gameStart;
@synthesize gameTimer;

- (id)initWithApp:(mines_AppDelegate *)delegate {
	if(self=[super init]) {
		self.dg = dg;
	}
	return self;
}

- (void)receiveClickAtRow:(NSInteger)row
					  col:(NSInteger)col {
	
}

@end
