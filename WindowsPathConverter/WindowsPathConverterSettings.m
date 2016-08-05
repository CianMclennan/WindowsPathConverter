//
//  WindowsPathConverterSettings.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 26/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#define WINDOWS_DRIVES @"windows_drives"

#import "WindowsPathConverterSettings.h"


@interface WindowsPathConverterSettings ()
@property(nonatomic, strong) NSDictionary* windowsDrives;
@end

@implementation WindowsPathConverterSettings

-(instancetype)initWithJSONFilePath:(NSURL *)url{
    self = [super initWithJSONFilePath:url];
    if(self){
        self.windowsDrives = self.settingsDictionary[WINDOWS_DRIVES];
    }
    return self;
}

@end
