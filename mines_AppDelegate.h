//
//  mines_AppDelegate.h
//  mines
//
//  Created by Chris Miller on 6/20/10.
//  Copyright FSDEV 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <math.h>
#import "Resources.h"
#import "HiScoresCtrllr.h"
@class Mines_Engine;

@interface mines_AppDelegate : NSObject 
{
    NSWindow *window;
    IBOutlet id minefield;
    IBOutlet id timer;
    IBOutlet id eventMask;
	IBOutlet NSTextField * textField;
	IBOutlet NSWindow * hiScoreWindow;
	IBOutlet NSTextField * hiScoresName;
	
	Mines_Engine * engine;
	HiScoresCtrllr * hiScoresCtrllr;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}


@property (nonatomic, retain) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet id minefield;
@property (nonatomic, retain) IBOutlet id timer;
@property (nonatomic, retain) IBOutlet id eventMask;
@property (nonatomic, retain) NSTextField * textField;
@property (nonatomic, retain) NSWindow * hiScoreWindow;
@property (nonatomic, retain) NSTextField * hiScoresName;

@property (nonatomic, retain) Mines_Engine * engine;
@property (nonatomic, retain) HiScoresCtrllr * hiScoresCtrllr;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:sender;
- (IBAction)showHighScores:(id)sender;
- (IBAction)performClick:(NSPoint)location
			  rightClick:(BOOL)rightClick;
- (IBAction)acceptHiScore:(id)sender;

@end
