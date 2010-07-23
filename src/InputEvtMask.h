//
//  InputEvtMask.h
//  mines
//
//  Created by Chris Miller on 6/24/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class mines_AppDelegate;

/**
 * Basically sits on top of the NSMatrix and sends mouse events to the app delegate.
 *
 * This is all because NSMatrix doesn't have an easy way of detecting right mouse clicks.
 * But NSMatrix does have a lovely way of taking NSPoints and getting a cell row/col out of it.
 */
@interface InputEvtMask : NSView {
	mines_AppDelegate * dg;
}

@property (nonatomic, assign) mines_AppDelegate * dg;

- (void)rightMouseUp:(NSEvent *)theEvent;
- (void)mouseUp:(NSEvent *)theEvent;

@end
