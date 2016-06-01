//
//  PathConverter.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 01/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathConverter : NSObject

-(NSString*) windowsToUnix:(NSString*) windowsString;
-(NSString*) unixToWindows:(NSString*) unixString;
-(BOOL) stringIsWindowsPath:(NSString*) path;

@end
