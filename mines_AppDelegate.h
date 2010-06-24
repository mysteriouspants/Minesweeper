//
//  mines_AppDelegate.h
//  mines
//
//  Created by Chris Miller on 6/20/10.
//  Copyright FSDEV 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Resources.h"
@class Mines_Engine;

@interface mines_AppDelegate : NSObject 
{
    NSWindow *window;
    IBOutlet id minefield;
    IBOutlet id timer;
	
	Mines_Engine * engine;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet id minefield;
@property (nonatomic, retain) IBOutlet id timer;

@property (nonatomic, retain) Mines_Engine * engine;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:sender;
- (IBAction)performClick:(id)sender;

@end
