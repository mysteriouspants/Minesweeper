//
//  FSZip.m
//  mines
//
//  Created by Chris Miller on 7/23/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import "FSZip.h"

@implementation FSZip

@synthesize lzip;

#pragma mark NSObject

- (id)init {
	if(self=[super init]) {
		lzip = NULL;
	}
	return self;
}

- (void)dealloc {
	if(lzip!=NULL) {
		int error = zip_close(lzip);
		switch (error) {
			case ZIP_ER_ZLIB:
				NSLog(@"FSZip: Error [de]compressing file.");
				break;
			case ZIP_ER_WRITE:
				NSLog(@"FSZip: Error writing to output file.");
				break;
			case ZIP_ER_EOF:
				NSLog(@"FSZip: Unexpected end-of-file found while reading from a file.");
				break;
			case ZIP_ER_INTERNAL:
				NSLog(@"FSZip: The callback function of an added or replaced file returned an error but failed to report which.");
				break;
			case ZIP_ER_INVAL:
				NSLog(@"FSZip: The path argument is NULL.");
				break;
			case ZIP_ER_MEMORY:
				NSLog(@"FSZip: Required memory could not be allocated.");
				break;
			case ZIP_ER_NOZIP:
				NSLog(@"FSZip: The file is not a zip archive, dude.");
				break;
			case ZIP_ER_READ:
				NSLog(@"FSZip: A file read failed.");
				break;
			case ZIP_ER_RENAME:
				NSLog(@"FSZip: A temporary file could not be renamed to its final name.");
				break;
			case ZIP_ER_SEEK:
				NSLog(@"FSZip: A file seek failed.");
				break;
			case ZIP_ER_IMPOPEN:
				NSLog(@"FSZip: A temporary file could not be created.");
				break;
			default:
				// do nothing
				break;
		}
	}
	[super dealloc];
}

@end
