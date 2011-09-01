//
//  HiScoresCtrllr.h
//  mines
//
//  Created by Chris Miller on 7/13/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HiScore.h"

@interface HiScoresCtrllr : NSWindowController < NSWindowDelegate, NSTableViewDataSource > {
    IBOutlet id scoresTable;
    NSArray * hiScores;
}

@property (nonatomic, retain) IBOutlet id scoresTable;
@property (nonatomic, retain) NSArray * hiScores;

- (void)scoresDidChange;

@end
