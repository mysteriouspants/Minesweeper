//
//  HiScoresCtrllr.m
//  mines
//
//  Created by Chris Miller on 7/13/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import "HiScoresCtrllr.h"

@implementation HiScoresCtrllr

@synthesize scoresTable;
@synthesize hiScores;

- (void)scoresDidChange {
	// load high scores
	NSLog(@"Attempting to update scores");
	NSManagedObjectContext * ctxt = [[NSApp delegate] managedObjectContext];
	NSError * error;
	NSFetchRequest * fetchRequest = [[[NSApp delegate] managedObjectModel] fetchRequestTemplateForName:@"highScores"];
	self.hiScores = [ctxt executeFetchRequest:fetchRequest error:&error];
	if(!error) {
		NSLog(@"Unable to retrieve any high scores");
	} else {
		if([hiScores count] == 0UL) {
			NSLog(@"No scores logged");
		} else {
			NSLog(@"%@", hiScores);
		}
	}
	[self.scoresTable reloadData];
}

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
			 
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	if(self.hiScores)
		return [self.hiScores count];
	else
		return 0;
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
			row:(NSInteger)rowIndex {
	if([[aTableView tableColumns] objectAtIndex:0] == aTableColumn) { // Player Name
		return [[NSString alloc] initWithString:[[hiScores objectAtIndex:rowIndex] playerName]];
	} else if([[aTableView tableColumns] objectAtIndex:1] == aTableColumn) { // Date
		return [[NSString alloc] initWithString:[[[hiScores objectAtIndex:rowIndex] gameStartDate] description]];
	} else { // time
		return [[NSString alloc] initWithString:[[hiScores objectAtIndex:rowIndex] prettyPrintGameLength]];
	}
}
			 
- (BOOL)tableView:(NSTableView *)aTableView
	   acceptDrop:(id < NSDraggingInfo >)info
			  row:(NSInteger)row
	dropOperation:(NSTableViewDropOperation)operation {
	return NO;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[hiScores release];
	[super dealloc];
}

@end
