//
//  HiScoresCtrllr.m
//  mines
//
//  Created by Chris Miller on 7/13/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import "HiScoresCtrllr.h"


@implementation HiScoresCtrllr

- (void)scoresDidChange {
	// load high scores
}

- (id)initWithWindowNibName:(NSString *)windowNibName {
	if(self=[super initWithWindowNibName:windowNibName]) {
		
	}
	return self;
}
		[[NSNotificationCenter defaultCenter] postNotificationName:];
- (void)windowDidLoad {
	[[super window] setDelegate:self];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(scoresDidChange)
												 name:@"FSDEV Mines high scores did change" 
											   object:nil];
	[self scoresDidChange];
}

- (void)windowWillClose:(NSNotification *)notification {
	[self release];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

@end
