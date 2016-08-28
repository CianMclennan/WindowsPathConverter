//
//  WindowsPathConverterSettings.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 26/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#define WINDOWS_DRIVES @"windows_drives"
#define DOCUMENTS_DIRECTORY [[[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"WindowsPathConverter"]

#import "WindowsPathConverterSettings.h"


@interface WindowsPathConverterSettings ()

@end

@implementation WindowsPathConverterSettings

-(NSDictionary *)windowsDrives{
    return self.settingsDictionary[WINDOWS_DRIVES];
}

-(void) removeWindowsDriveWithKey:(NSString*) key
{
    NSMutableDictionary* windowsDrives = [self.windowsDrives mutableCopy];
    [windowsDrives removeObjectForKey:key];
    [self updateSettingsWithObject:windowsDrives forKey:WINDOWS_DRIVES];
    [self save];
}

+ (id)sharedSettings {
    static WindowsPathConverterSettings *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL *settingsFile = [DOCUMENTS_DIRECTORY URLByAppendingPathComponent:@"settings.json"
                                                                                    isDirectory:NO];
        if(![[NSFileManager defaultManager] fileExistsAtPath:[settingsFile path]])
        {
            NSError* error;
            NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"json"];
            [[NSFileManager defaultManager] createDirectoryAtPath: [DOCUMENTS_DIRECTORY path]
                                      withIntermediateDirectories: YES
                                                       attributes: nil
                                                            error: &error];
            if(error){
                NSLog(@"Cannot create documents directory.");
            }
            [[NSFileManager defaultManager] copyItemAtPath:path toPath:[settingsFile path] error:&error];
            if(error){
                NSLog(@"Cannot create settings file.");
            }
        }
        
        sharedMyManager = [[self alloc] initWithJSONFilePath:settingsFile];
        
    });
    
    return sharedMyManager;
}

@end
