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

BOOL res_init = FALSE;

NSDictionary * gResources;
NSDictionary * gCurrentImageSet;
NSDictionary * gImageEnumMap;
NSMutableDictionary * gImageCache;
NSString * gCurrentImageSetName;
FSZip * gfx;

mines_AppDelegate * appDg;

void injectAppDelegate(mines_AppDelegate * dg) {
    appDg = dg;
     // sendActionOn:NSLeftMouseDownMask|NSRightMouseDownMask
}

BOOL resources_init() {
    if(res_init)
        return res_init;
    else
        NSLog(@"Initializing resource system");
    NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
    gResources = [[NSDictionary alloc] initWithContentsOfFile:
                   [NSString stringWithFormat:@"%@/Resources.plist",
                    [[NSBundle mainBundle] resourcePath]]];
    if(gResources == nil) {
        NSLog(@"FATAL: Cannot find Resources.plist!");
        return FALSE;
    }
    gCurrentImageSetName = @"mcspider_art";
    gCurrentImageSet = [[gResources objectForKey:@"Image Sets"]
                           objectForKey:gCurrentImageSetName];
    gImageEnumMap = [gResources objectForKey:@"Image Enum Mappings"];
    // change all the keys from NSString to NSNumber
    NSMutableDictionary * d = [[NSMutableDictionary alloc] init];
    for(NSString * str in gImageEnumMap) {
        [d setObject:[gImageEnumMap objectForKey:str]
              forKey:[NSNumber numberWithInteger:[str integerValue]]];
    }
    gImageEnumMap = [[NSDictionary dictionaryWithDictionary:d] retain];
    
    
    gfx = [[FSZip alloc] initWithFileName:[NSString stringWithFormat:@"%@/gfx.zip",[[NSBundle mainBundle] resourcePath]]];
    NSLog(@"FSZip sees %d files.",[gfx files]);
    NSLog(@"FSZip sees: %@",[gfx containedFiles]);
    
    if(gfx==nil) {
        NSLog(@"Cannot open gfx archive!");
        res_init = FALSE;
        return res_init;
    }
    
    gImageCache = [[NSMutableDictionary alloc] init];
    
    [pool0 release];
    res_init = TRUE;
    return res_init;
}

bool putImageAtTile(const IMAGE image_id, const NSInteger x, const NSInteger y) {
    if(!resources_init()) {
        NSLog(@"Resource system initialization failed.  Failing to set image.");
        return FALSE;
    }
    NSImageCell * c = [[appDg minefield] cellAtRow:x column:y];
    if(c==nil) {
        c = [[NSImageCell alloc] init];
        [[appDg minefield] putCell:c atRow:x column:y];
    }
    [c setImage:getImage(image_id)];
    return TRUE;
}
// set to false to emit information about images
NSImage * getImage(const IMAGE image_id) {
    if(!resources_init())
        return nil;
    NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
    NSString * image_name = [gImageEnumMap objectForKey:
                             [NSNumber numberWithInteger:image_id]];
    NSString * image_file = [gCurrentImageSet objectForKey:image_name];
    NSImage * i = [gImageCache objectForKey:image_file];
    if(i==nil) {
        i = [[NSImage alloc] initWithData:[gfx dataForFile:image_file]];
        [gImageCache setObject:[i autorelease]
                          forKey:image_file];
    }
//  [image_file release];
//  [image_name release];
    [pool0 release];
    return i;
}
