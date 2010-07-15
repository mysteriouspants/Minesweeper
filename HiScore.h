//
//  HiScore.h
//  mines
//
//  Created by Chris Miller on 7/13/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface HiScore :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * gameStartDate;
@property (nonatomic, retain) NSDate * gameStopDate;
@property (nonatomic, retain) NSString * playerName;

@end



