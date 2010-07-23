/**
 * Obfuscates the use of a ZIP file through libzip into a nice Cocoa class.
 * @dependencies
 * >= libzip-0.9
 *  zlib
 * (C) 2010 FSDEV.  All rights reserved.
 * This code is two-clause BSD licensed.
 */

#import <Cocoa/Cocoa.h>
#include <zip.h>

@interface FSZip : NSObject {
	struct zip * lzip;
}

@property(readwrite,assign) struct zip * lzip;

- (id)initWithFileName:(NSString *)file;

@end
