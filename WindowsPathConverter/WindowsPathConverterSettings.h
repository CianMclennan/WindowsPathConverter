//
//  WindowsPathConverterSettings.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 26/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "Settings.h"

@interface WindowsPathConverterSettings : Settings

@property(readonly) NSDictionary* volumes;

+ (WindowsPathConverterSettings*)sharedSettings;
-(void) removeMacVolume:(NSString*) volume;
-(void) removeWindowsDrive:(NSString*)windowsDrive fromMacVolume:(NSString*) volume;
-(void) assignWindowsDrive:(NSString*) windowsDrive toMacVolume:(NSString*) volume;

@end
