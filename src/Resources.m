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
NSMutableDictionary * __image_cache;
NSString * __current_image_set_name;
FSZip * __gfx;

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
	__current_image_set_name = @"mcspider_art";
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
	
	
	__gfx = [[FSZip alloc] initWithFileName:[NSString stringWithFormat:@"%@/gfx.zip",[[NSBundle mainBundle] resourcePath]]];
	NSLog(@"FSZip sees %d files.",[__gfx files]);
	NSLog(@"FSZip sees: %@",[__gfx containedFiles]);
	
	if(__gfx==nil) {
		NSLog(@"Cannot open gfx archive!");
		__res_init = FALSE;
		return __res_init;
	}
    
    __image_cache = [[NSMutableDictionary alloc] init];
	
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
NSImage * getImage(const IMAGE image_id) {
	if(!__resources_init())
		return nil;
	NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
	NSString * image_name = [__image_enum_map objectForKey:
							 [NSNumber numberWithInteger:image_id]];
	NSString * image_file = [__current_image_set objectForKey:image_name];
    NSImage * i = [__image_cache objectForKey:image_file];
    if(i==nil) {
        i = [[NSImage alloc] initWithData:[__gfx dataForFile:image_file]];
        [__image_cache setObject:[i autorelease]
                          forKey:image_file];
    }
//	[image_file release];
//	[image_name release];
	[pool0 release];
	return i;
}
