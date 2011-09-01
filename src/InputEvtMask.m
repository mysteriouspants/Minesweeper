//
//  InputEvtMask.m
//  mines
//
//  Created by Chris Miller on 6/24/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import "InputEvtMask.h"
#import "mines_AppDelegate.h"

@implementation InputEvtMask

@synthesize dg;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    // it's freaking transparent!
}

- (void)rightMouseUp:(NSEvent *)theEvent {
    NSPoint locationInWindow = [theEvent locationInWindow];
    locationInWindow = NSMakePoint(locationInWindow.y, locationInWindow.x);
    [self.dg performClick:[self convertPoint:[theEvent locationInWindow]
                                    fromView:nil]
               rightClick:YES];
}

- (void)mouseDown:(NSEvent *)theEvent {
    
}

- (void)mouseUp:(NSEvent *)theEvent {
    NSPoint locationInWindow = [theEvent locationInWindow];
    locationInWindow = NSMakePoint(locationInWindow.y, locationInWindow.x);
    BOOL rightClick=NO;
    if([theEvent modifierFlags] & NSControlKeyMask)
        rightClick = YES;
    [self.dg performClick:[self convertPoint:[theEvent locationInWindow]
                                    fromView:nil]
               rightClick:rightClick];
}

@end
