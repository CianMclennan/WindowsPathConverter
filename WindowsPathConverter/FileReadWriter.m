//
//  FileReadWriter.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 01/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "FileReadWriter.h"

@implementation FileReadWriter

+ (void) writeText:(NSString*) text toFile:(NSURL*) url
{
    NSError* error;
    [text writeToFile:url.path atomically:NO encoding:NSStringEncodingConversionAllowLossy error:&error];
    if(error) NSLog(@"%@", error);
}

+ (NSString*) readTextFromURL:(NSURL*) url
{
    NSString* text = [NSString stringWithContentsOfFile:url.path encoding:NSUTF8StringEncoding error:nil];
    return text;
}

@end
