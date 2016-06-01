//
//  FileReadWriter.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 01/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileReadWriter : NSObject

+ (void) writeText:(NSString*) text toFile:(NSURL*) url;
+ (NSString*) readTextFromURL:(NSURL*) url;

@end
