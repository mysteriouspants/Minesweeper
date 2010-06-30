/*
 *  Resources.m
 *  mines
 *
 *  Created by Chris Miller on 6/22/10.
 *  Copyright 2010 FSDEV. All rights reserved.
 *
 */

#import "Resources.h"

#import "mines_AppDelegate.h"

BOOL __res_init = FALSE;

NSDictionary * __resources;
NSDictionary * __current_image_set;
NSDictionary * __image_enum_map;
NSString * __current_image_set_name;

__weak mines_AppDelegate * __appDg;

void injectAppDelegate(mines_AppDelegate * dg) {
	__appDg = dg;
	 // sendActionOn:NSLeftMouseDownMask|NSRightMouseDownMask
}

BOOL __resources_init() {
	if(__res_init)
		return __res_init;
	else
		NSLog(@"Initializing resource system");
	NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
	__resources = [[NSDictionary alloc] initWithContentsOfFile:
				   [NSString stringWithFormat:@"%@/Resources.plist",
					[[NSBundle mainBundle] resourcePath]]];
	if(__resources == nil) {
		NSLog(@"FATAL: Cannot find Resources.plist!");
		return FALSE;
	}
	__current_image_set_name = @"programmer_art";
	__current_image_set = [[__resources objectForKey:@"Image Sets"]
						   objectForKey:__current_image_set_name];
	__image_enum_map = [__resources objectForKey:@"Image Enum Mappings"];
	// change all the keys from NSString to NSNumber
	NSMutableDictionary * d = [[NSMutableDictionary alloc] init];
	for(NSString * str in __image_enum_map) {
		[d setObject:[__image_enum_map objectForKey:str]
			  forKey:[NSNumber numberWithInteger:[str integerValue]]];
	}
	__image_enum_map = [[NSDictionary dictionaryWithDictionary:d] retain];
	[pool0 release];
	__res_init = TRUE;
	return __res_init;
}

bool putImageAtTile(const IMAGE image_id, const NSInteger x, const NSInteger y) {
	if(!__resources_init()) {
		NSLog(@"Resource system initialization failed.  Failing to set image.");
		return FALSE;
	}
	NSImageCell * c = [[__appDg minefield] cellAtRow:x column:y];
	if(c==nil) {
		c = [[NSImageCell alloc] init];
		[[__appDg minefield] putCell:c atRow:x column:y];
	}
	[c setImage:getImage(image_id)];
	return TRUE;
}
// set to false to emit information about images
#define RESOURCE_PROBLEMS FALSE
NSImage * getImage(const IMAGE image_id) {
	if(!__resources_init())
		return nil;
	NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
	if(RESOURCE_PROBLEMS) {
		NSLog(@"Getting Image:");
		NSLog(@"    Image ID:   %d", image_id);
	}
	NSString * image_name = [__image_enum_map objectForKey:
							 [NSNumber numberWithInteger:image_id]];
	if(RESOURCE_PROBLEMS)
		NSLog(@"    Image Name: %@", image_name);
	NSString * image_file = [__current_image_set objectForKey:image_name];
	if(RESOURCE_PROBLEMS)
		NSLog(@"    Image File: %@", image_file);
	
	NSString * path = [[NSString alloc] initWithFormat:@"%@/%@",
					   [[NSBundle mainBundle] resourcePath],
					   image_file];
	NSImage * i = [[NSImage alloc] initWithContentsOfFile:path];
	[path release];
	[pool0 release];
	if(RESOURCE_PROBLEMS)
		if(i == nil)
			NSLog(@"    returning nil");
		else
			NSLog(@"    returning image");
	return [i autorelease];
}
