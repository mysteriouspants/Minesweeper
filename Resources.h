/*
 *  Resources.h
 *  mines
 *
 *  Created by Chris Miller on 6/22/10.
 *  Copyright 2010 FSDEV. All rights reserved.
 *
 */

@class mines_AppDelegate;

typedef enum {
	BLANK_TILE=0,
	BOMB_TILE,
	QUESTION_MARK,
	FLAG_TILE,
	NUM_1,
	NUM_2,
	NUM_3,
	NUM_4,
	NUM_5,
	NUM_6,
	NUM_7,
	NUM_8
} IMAGE;

void injectAppDelegate(mines_AppDelegate * dg);

bool putImageAtTile(const IMAGE image_id, const NSInteger x, const NSInteger y);

// gets the corresponding image.  Use the IMAGES enumeration.
NSImage * getImage(const IMAGE image_id);

// sets the current image set.  eg. @"programmer art"
bool setImageSet(NSString * imageSet);
