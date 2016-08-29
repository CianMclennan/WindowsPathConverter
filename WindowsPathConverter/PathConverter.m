//
//  PathConverter.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 01/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "PathConverter.h"

@interface PathConverter ()

@property (nonatomic, strong) NSDictionary* conversionStrings;

@end

@implementation PathConverter

-(instancetype)initWithConversionStrings:(NSDictionary*) conversionStrings
{
    if(self=[super init]) {
        self.conversionStrings = conversionStrings;
    }
    return self;
}

-(NSString*) windowsToUnix:(NSString*) windowsString
{
    for (NSString* volume in self.conversionStrings)
    {
        NSArray* drives = self.conversionStrings[volume];
        for (NSString* drive in drives)
        {
            if([[windowsString lowercaseString] rangeOfString:[drive lowercaseString]].location != NSNotFound){
                NSString* macVolume = [NSString stringWithFormat:@"/Volumes/%@", volume];
                NSRange rangeOfWindowsDrive = [[windowsString lowercaseString] rangeOfString:[drive lowercaseString]];
                NSUInteger lengthOfString = rangeOfWindowsDrive.location+rangeOfWindowsDrive.length;
                NSString* unixString = [NSString stringWithFormat:@"%@%@", macVolume, [windowsString substringWithRange: NSMakeRange(lengthOfString, windowsString.length-lengthOfString)]];
                unixString = [unixString stringByReplacingOccurrencesOfString:@"\\"
                                                                   withString: @"/"];
                return unixString;
            }
        }
    }
    return windowsString;
}

-(NSString*) unixToWindows:(NSString*) unixString
{
    NSString* macVolume = @"";
    @try {
        NSArray* pathElements = [unixString componentsSeparatedByString:@"/"];
        if (![pathElements[1] isEqualToString:@"Volumes"])
            return unixString;
        macVolume = [pathElements objectAtIndex:2];
    } @catch (NSException *exception) {
        return unixString;
    }
    NSArray* drives = self.conversionStrings[macVolume];
    if(drives)
    {
        NSString* windowsDrive = [self.conversionStrings[macVolume] firstObject];
        if(windowsDrive) {
            macVolume = [NSString stringWithFormat:@"/Volumes/%@", macVolume];
            NSString* windowsString = [unixString stringByReplacingOccurrencesOfString:macVolume
                                                                            withString:windowsDrive];
            windowsString = [windowsString stringByReplacingOccurrencesOfString:@"/" withString:@"\\"];
            return windowsString;
        }
    }
    return unixString;
}

-(BOOL) stringIsWindowsPath:(NSString*) path
{
    path = [path lowercaseString];
    for (NSString* volume in self.conversionStrings) {
        NSArray* drives = self.conversionStrings[volume];
        for (NSString* drive in drives) {
            if([path rangeOfString:[drive lowercaseString]].location != NSNotFound)
                return YES;
        }
    }
    return NO;
}

-(BOOL) stringIsMacPath:(NSString*) path{
    NSString* macVolume = [[path componentsSeparatedByString:@"/"] objectAtIndex:1];
    return self.conversionStrings[macVolume] ? YES : NO;
}
@end
