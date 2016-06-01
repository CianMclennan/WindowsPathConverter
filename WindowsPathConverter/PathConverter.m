//
//  PathConverter.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 01/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "PathConverter.h"

@implementation PathConverter{
    NSDictionary* _conversionStrings;
}

-(instancetype)initWithConversionStrings:(NSDictionary*) conversionStrings
{
    if(self=[super init]) {
        _conversionStrings = conversionStrings;
    }
    return self;
}

-(NSString*) windowsToUnix:(NSString*) windowsString
{
    for (NSString* key in _conversionStrings) {
        NSString* windowsDrive = key;
        NSString* macVolume = [NSString stringWithFormat:@"/Volumes/%@", [_conversionStrings objectForKey:key]];
        
        if ([windowsString rangeOfString:key].location != NSNotFound) {
            NSString* unixString = [windowsString stringByReplacingOccurrencesOfString:windowsDrive withString:macVolume];
            unixString = [unixString stringByReplacingOccurrencesOfString:@"\\" withString: @"/"];
            return unixString;
        }
    }
    return windowsString;
}

-(NSString*) unixToWindows:(NSString*) unixString
{
    for (NSString* key in _conversionStrings) {
        NSString* windowsDrive = key;
        NSString* macVolume = [NSString stringWithFormat:@"/Volumes/%@", [_conversionStrings objectForKey:key]];
        
        if ([unixString rangeOfString:macVolume].location != NSNotFound) {
            NSString* windowsString = [unixString stringByReplacingOccurrencesOfString:macVolume withString:windowsDrive];
            windowsString = [windowsString stringByReplacingOccurrencesOfString:@"/" withString:@"\\"];
            return windowsString;
        }
    }
    return unixString;
}

-(BOOL) stringIsWindowsPath:(NSString*) path
{
    for (NSString* key in _conversionStrings) {
        if([path rangeOfString:key].location != NSNotFound)
            return YES;
    }
    return NO;
}
@end
