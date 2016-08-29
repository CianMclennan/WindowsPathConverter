//
//  WindowsPathConverterSettings.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 26/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#define VOLUMES @"volumes"
#define DOCUMENTS_DIRECTORY [[[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"WindowsPathConverter"]

#import "WindowsPathConverterSettings.h"


@interface WindowsPathConverterSettings ()

@end

@implementation WindowsPathConverterSettings

-(NSDictionary *)volumes{
    return self.settingsDictionary[VOLUMES];
}

-(void) assignWindowsDrive:(NSString*) windowsDrive toMacVolume:(NSString*) volume
{
    NSMutableDictionary* volumes = [self.volumes mutableCopy];
    NSMutableOrderedSet* windowsDrives = [volumes[volume] mutableCopy];
    if(windowsDrives){
        [windowsDrives addObject:windowsDrive];
        volumes[volume] = windowsDrives;
    } else {
        volumes[volume] = @[windowsDrive];
    }
    [self updateSettingsWithObject:volumes forKey:VOLUMES];
    [self save];
}

-(void) removeMacVolume:(NSString*) volume
{
    NSMutableDictionary* volumes = [self.volumes mutableCopy];
    [volumes removeObjectForKey:volume];
    [self updateSettingsWithObject:volumes forKey:VOLUMES];
    [self save];
}

-(void) removeWindowsDrive:(NSString*)windowsDrive fromMacVolume:(NSString*) volume
{
    NSMutableDictionary* volumes = [self.volumes mutableCopy];
    NSMutableOrderedSet* windowsDrives = [volumes[volume] mutableCopy];
    for (NSString* drive in windowsDrives) {
        if ([[drive lowercaseString] isEqualToString:[windowsDrive lowercaseString]]){
            [windowsDrives removeObject:drive];
            break;
        }
    }
    if (windowsDrives.count){
        volumes[volume] = windowsDrives;
    } else {
        [volumes removeObjectForKey:volume];
    }    
    
    [self updateSettingsWithObject:volumes forKey:VOLUMES];
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
