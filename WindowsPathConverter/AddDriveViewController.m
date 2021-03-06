//
//  AddDriveViewController.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 28/08/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "AddDriveViewController.h"
#import "WindowsPathConverterSettings.h"
#import "PrefrencesWindowController.h"

@interface AddDriveViewController ()

@end

@implementation AddDriveViewController

-(void)viewWillAppear{
    [super viewWillAppear];
    self.windowsPath.stringValue = @"";
    self.macPath.stringValue = @"";
}

- (IBAction)addButton:(NSButton *)sender {
    if (self.windowsPath.stringValue.length && self.macPath.stringValue.length)
    {
        [WindowsPathConverterSettings.sharedSettings assignWindowsDrive:self.windowsPath.stringValue
                                                            toMacVolume:self.macPath.stringValue];
        [WindowsPathConverterSettings.sharedSettings save];
        [self windowWillClose];
        [self.window close];
        return;
    }
    NSLog(@"error");
}

- (IBAction)cancelButton:(NSButton *)sender {
    [self windowWillClose];
    [self.window close];
}

-(void)windowWillClose {
    NSWindow* w = PrefrencesWindowController.sharedPrefsWindowController.window;
    [w endSheet:self.window];
}
@end
