//
//  WindowsPathConverterSettings.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 26/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "Settings.h"

@interface WindowsPathConverterSettings : Settings

@property(readonly) NSDictionary* windowsDrives;

+ (WindowsPathConverterSettings*)sharedSettings;
- (void)removeWindowsDriveWithKey:(NSString*) key;

@end
