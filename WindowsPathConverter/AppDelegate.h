//
//  AppDelegate.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 25/04/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Sparkle/Sparkle.h>
#import "StatusItem.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate, NSMenuDelegate>

@property (weak) IBOutlet SUUpdater *updater;
@property (weak) IBOutlet StatusItem *statusButton;

@end

