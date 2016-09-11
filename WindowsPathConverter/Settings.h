//
//  Settings.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 26/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Settings : NSObject

@property (readonly) NSDictionary* settingsDictionary;

- (instancetype)initWithTemplateSettings: (NSURL*) settingsFile override: (BOOL) shouldOverride;
- (instancetype)initWithJSONFilePath:(NSURL*)url;
- (void) setObject:(id) object forKey:(NSString*) key;
- (void) removeObjectForKey:(NSString*) key;
- (BOOL) saveToURL:(NSURL*) url;
- (BOOL) save;

@end
