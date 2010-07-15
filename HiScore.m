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

- (NSString*)description {
	return [NSString stringWithFormat:@"\"High Score\" : {\n\t\"startDate\" : \"%@\";\t\n\"stopDate\" : \"%@\"\n\t\"playerName\" : \"%@\"\n}",
			self.gameStartDate,
			self.gameStopDate,
			self.playerName];
}

@end
