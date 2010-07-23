//
//  FSZip.m
//  mines
//
//  Created by Chris Miller on 7/23/10.
//  Copyright 2010 FSDEV. All rights reserved.
//

#import "FSZip.h"

void logErrorStuff(int error) {
	switch (error) {
		case ZIP_ER_OPEN:
			NSLog(@"FSZip: Cannot open archive for reading.");
			break;
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
		case ZIP_ER_TMPOPEN:
			NSLog(@"FSZip: A temporary file could not be created.");
			break;
		default:
			// do nothing
			NSLog(@"FSZip: Returned error code %d.",error);
			break;
	}	
}

@implementation FSZip

@synthesize lzip;
@synthesize chunksize;
@synthesize inbuff;
//@synthesize files;

- (id)initWithFileName:(NSString *)file {
	if(self=[self init]) {
#if DEBUG
		NSLog(@"FSZip: Attempting to open %@ as ZIP file.",file);
#endif
		int error=0;
		lzip = zip_open([file UTF8String], 0, &error);
		if(error!=0) {
			logErrorStuff(error);
			return nil;
		}
	}
	return self;
}

- (NSArray*)containedFiles {
	NSMutableArray * _files = [[NSMutableArray alloc] initWithCapacity:self.files];
	for(int i=0; i<self.files; ++i)
		[_files addObject:[NSString stringWithUTF8String:zip_get_name(lzip, i, 0)]];
	return [NSArray arrayWithArray:[_files autorelease]];
}

/**
 * Grabs the entire file and puts it into an NSData object.
 *
 * Not a good idea for especially large files.
 */
- (NSData *)dataForFile:(NSString *)file {
	NSAutoreleasePool * pool0 = [[NSAutoreleasePool alloc] init];
	struct zip_file * zf = zip_fopen(lzip,[file UTF8String], ZIP_FL_COMPRESSED);
	if(zf==NULL) {
		NSLog(@"FSZip: Unable to load %@",file);
		return nil;
	}
	NSMutableData * zdata = [[NSMutableData alloc] init];
	void * stuff = (void*)malloc(sizeof(void)*chunksize);
	int read;
	do {
		read = zip_fread(zf, stuff, sizeof(void)*chunksize);
		[zdata appendBytes:stuff
					length:read];
	} while (read>0);
	free(stuff);
	[pool0 release];
	return [NSData dataWithData:[zdata autorelease]];
}

/**
 * Grabs the entire file and puts it into a void array, returning by reference
 * the length of the array.
 *
 * Not a good idea for especially large files.
 */
- (void *)cDataForFile:(NSString *)file
			  ofLength:(size_t*)len {
	struct zip_file * zf = zip_fopen(lzip,[file UTF8String], ZIP_FL_COMPRESSED);
	if(zf==NULL) {
		NSLog(@"FSZip: Unable to load %@",file);
		(*len) = 0;
		return NULL;
	}
	void * toReturn = (void *)malloc(sizeof(void)*chunksize);
	int read;
	do {
		read = zip_fread(zf, toReturn+read, sizeof(void)*chunksize);
		toReturn = (void *)realloc(toReturn, read+sizeof(void)*chunksize);
	} while (read>0);
	return toReturn;
}

/**
 * Reads <code>chunksize</code> bytes from the specified zip file into <code>buff</code>
 * and returning by reference <code>bytes</code> bytes read.  You are responsible for
 * ensuring that <code>buff</code> has enough memory to accept <code>chunksize</code>
 * bytes, or you will be overwriting other memory and perhaps incur major errors.
 *
 * This is a streaming tool.  This is good if you have a file that is larger than
 * 1MiB that you're attempting to perform some kind of streamable operation on.
 */
- (void)readCDataFromFile:(struct zip_file *)file
					 into:(void *)buff
				bytesRead:(size_t *)bytes {
	(*bytes) = zip_fread(file, buff, chunksize);
}

/**
 * Returns the zip_file structure associated with a specific file name; used in
 * conjunction with <code>readCDataFromFile:bytesRead:</code>.
 */
- (struct zip_file *)cFileForName:(NSString *)file {
	struct zip_file * zf = zip_fopen(lzip,[file UTF8String], ZIP_FL_COMPRESSED);
	if(zf==NULL) {
		NSLog(@"FSZip: Unable to load %@",file);
		return NULL;
	}
	return zf;
}

- (int)files {
	if(files==-1)
		files = zip_get_num_files(lzip);
	return files;
}

#pragma mark NSObject

- (id)init {
	if(self=[super init]) {
		lzip = NULL;
		chunksize=1024;
		inbuff=NULL;
		files=-1;
	}
	return self;
}

- (void)dealloc {
	if(lzip!=NULL) {
		int error = zip_close(lzip);
		if(error!=0)
			logErrorStuff(error);
	}
	if(inbuff!=NULL)
		free(inbuff);
	[super dealloc];
}

@end
