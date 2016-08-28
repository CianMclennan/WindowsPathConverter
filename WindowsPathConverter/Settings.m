//
//  Settings.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 26/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "Settings.h"
#import "JSONParser.h"

@interface Settings ()

@property (strong, nonatomic) NSDictionary* settingsDictionary;
@property (strong, nonatomic) NSURL* settingsURL;

@end

@implementation Settings

- (instancetype)initWithJSONFilePath:(NSURL*)url;
{
    self = [super init];
    if (self) {
        self.settingsURL = url;
        self.settingsDictionary = [JSONParser dictionaryFromJSON:url];
    }
    return self;
}

- (void) updateSettingsWithObject:(id) object forKey:(NSString*) key
{
    NSMutableDictionary* newSettings = [self.settingsDictionary mutableCopy];
    newSettings[key] = object;
    self.settingsDictionary = [newSettings copy];
}
//- (void) removeObjectForKey:(NSString*) key
//{
//    NSMutableDictionary* newSettings = [self.settingsDictionary mutableCopy];
//    [newSettings removeObjectForKey:key];
//    self.settingsDictionary = [newSettings copy];
//}

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
