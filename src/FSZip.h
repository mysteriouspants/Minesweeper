/**
 * Obfuscates the use of a ZIP file through libzip into a nice Cocoa class.  Like most good
 * things in life, this is not thread-safe.
 *
 * Download, build, and install libzip from http://nih.at/libzip.  (usual ./configure, make,
 * make install routine).
 *
 * Copy libzip.1.0.0.dylib to your Xcode project's Linked Frameworks directory.
 * 
 * Next run the following on the dylib in your project directory:
 *		install_name_tool -id @executable_path/../Frameworks/libssh2.1.dylib libssh2.1.dylib
 * 
 * This causes the dylib to link to itself, instead of a (potentially nonexistant) dylib
 * in /usr/local/lib.
 *
 * Now create a "Copy Files" build phase in Xcode.  Set the destination to "Frameworks," then
 * drag the dylib from the Linked Frameworks group to this new copy files build step.  I suggest
 * you rename the build step to something more descriptive.
 * 
 * Finally, create a "Run Script" build phase in Xcode to run the following script:
 *		ABS_PATH="/usr/local/lib/libzip1.0.0.dylib"
 *		REL_PATH="@executable_path/../Frameworks/libzip1.0.0.dylib"
 *		install_name_tool -change $ABS_PATH $REL_PATH $TARGET_BUILD_DIR/$EXECUTABLE_PATH
 * I suggest you rename this to something more descriptive, as well.
 *
 * Or, the not so fun way...
 *
 * ./configure --enable-static --disable-shared
 * make
 * make install
 *
 * and link against libzip.a
 *
 * Which so so totally not as much fun.
 * 
 * @dependencies
 * >= libzip-0.9
 *  zlib
 * (C) 2010 FSDEV.  All rights reserved.
 * This code is two-clause BSD licensed.
 */

#import <Cocoa/Cocoa.h>
#include <zip.h>
#include <stdlib.h>

@interface FSZip : NSObject {
	struct zip * lzip;
	int chunksize;
	void * inbuff;
	int files;
}

@property(readwrite,assign) struct zip * lzip;	//! it is inadvisable to modify this
@property(readwrite,assign) int chunksize;		//! how many bytes to read at a time
@property(readwrite,assign) void * inbuff;		//! input buffer pointer
@property(readonly) int files;					//! number of files in the archive

- (id)initWithFileName:(NSString *)file;		//! initialize with a zip file
- (NSArray *)containedFiles;					//! listing of contained files

/**
 * Grabs the entire file and puts it into an NSData object.
 *
 * Not a good idea for especially large files.
 */
- (NSData *)dataForFile:(NSString *)file;

/**
 * Grabs the entire file and puts it into a void array, returning by reference
 * the length of the array.
 *
 * Not a good idea for especially large files.
 */
- (void *)cDataForFile:(NSString *)file
			  ofLength:(size_t*)len;

/**
 * Reads <code>chunksize</code> bytes from the specified zip file into <code>buff</code>
 * and returning by reference <code>bytes</code> bytes read.
 *
 * This is a streaming tool.  This is good if you have a file that is larger than
 * 1MiB that you're attempting to perform some kind of streamable operation on.
 */
- (void)readCDataFromFile:(struct zip_file *)file
					 into:(void *)buff
				bytesRead:(size_t *)bytes;

/**
 * Returns the zip_file structure associated with a specific file name; used in
 * conjunction with <code>readCDataFromFile:bytesRead:</code>.
 */
- (struct zip_file *)cFileForName:(NSString *)file;

@end
