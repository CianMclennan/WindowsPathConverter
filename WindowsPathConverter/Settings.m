//
//  Settings.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 26/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "Settings.h"
#import "JSONParser.h"

#define DOCUMENTS_DIRECTORY [[[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:[[NSProcessInfo processInfo] processName]]

@interface Settings ()

@property (strong, nonatomic) NSDictionary* settingsDictionary;
@property (strong, nonatomic) NSURL* settingsURL;

@end

@implementation Settings


- (instancetype)init
{
    NSURL *settingsFile = [DOCUMENTS_DIRECTORY URLByAppendingPathComponent:@"settings.json"
                                                               isDirectory:NO];
    return [self initWithTemplateSettings:settingsFile override:NO];
}

- (instancetype)initWithJSONFilePath:(NSURL*)url
{
    self = [super init];
    if (self) {
        self.settingsURL = url;
        self.settingsDictionary = [JSONParser dictionaryFromJSON:url];
    }
    return self;
}

- (instancetype)initWithTemplateSettings: (NSURL*) settingsFile override: (BOOL) shouldOverride
{
    if([[NSFileManager defaultManager] fileExistsAtPath:[settingsFile path]]) {
        if (shouldOverride){
            NSError* error;
            [[NSFileManager defaultManager] removeItemAtPath:[settingsFile path] error:&error];
            if (error)
                @throw [NSException exceptionWithName:@"Delete File Exception" reason:error.description userInfo:nil];
        }
        else {
            return [self initWithJSONFilePath:settingsFile];
        }
    }
    self = [super init];
    if (self) {
        self.settingsURL = settingsFile;
        NSError* error;
        [[NSFileManager defaultManager] createDirectoryAtPath: [DOCUMENTS_DIRECTORY path]
                                  withIntermediateDirectories: YES
                                                   attributes: nil
                                                        error: &error];
        if(error){
            @throw [NSException exceptionWithName:@"DirectoryCreationException" reason:[NSString stringWithFormat:@"Cannot create documents directory at %@", DOCUMENTS_DIRECTORY] userInfo:nil];
        }
        [[NSFileManager defaultManager] createFileAtPath:[settingsFile path] contents:nil attributes:nil];
        self.settingsDictionary = [NSDictionary dictionary];
        [self save];
    }
    return [self init];
}

- (void) setObject:(id) object forKey:(NSString*) key
{
    NSMutableDictionary* newSettings = [self.settingsDictionary mutableCopy];
    newSettings[key] = object;
    self.settingsDictionary = [newSettings copy];
}
- (void) removeObjectForKey:(NSString*) key
{
    NSMutableDictionary* newSettings = [self.settingsDictionary mutableCopy];
    [newSettings removeObjectForKey:key];
    self.settingsDictionary = [newSettings copy];
}

-(BOOL) saveToURL:(NSURL*) url
{
    @try {
        [JSONParser writeDictionary:self.settingsDictionary toJSONFile:url];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        return NO;
    }
    return YES;
}
-(BOOL) save
{
    return [self saveToURL:self.settingsURL];
}

@end
