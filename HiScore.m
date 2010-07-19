// 
//  HiScore.m
//  mines
//
//  Created by Chris Miller on 7/13/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import "HiScore.h"


@implementation HiScore 

@dynamic gameStartDate;
@dynamic gameStopDate;
@dynamic playerName;

- (NSTimeInterval)gameLength {
	return [self.gameStopDate timeIntervalSinceDate:self.gameStartDate];
}

- (NSString*)prettyPrintGameLength {
	NSTimeInterval seconds = [self.gameStopDate timeIntervalSinceDate:self.gameStartDate];
	NSInteger minutes = ((NSInteger)((CGFloat)seconds/60.0f));
	NSString * toPost = [NSString stringWithFormat:@"%02d M %02d S",
						 minutes,
						 ((NSInteger)seconds) - (minutes*60)];
	return [toPost autorelease];
}

- (NSString*)description {
	return [NSString stringWithFormat:@"\"High Score\" : {\n\t\"startDate\" : \"%@\";\t\n\"stopDate\" : \"%@\"\n\t\"playerName\" : \"%@\"\n}",
			self.gameStartDate,
			self.gameStopDate,
			self.playerName];
}

@end
