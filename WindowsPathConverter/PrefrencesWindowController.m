//
//  PrefrencesWindowController.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 11/09/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "PrefrencesWindowController.h"

@interface PrefrencesWindowController ()

@end

@implementation PrefrencesWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.delegate = self;
}

- (void)setupToolbar{
    
    [self addView:self.drivesPreferenceView label:@"Drives" image:[NSImage imageNamed:@"WindowsDriveIcon"]];
    [self addView:self.generalPreferenceView label:@"General" image:[NSImage imageNamed:@"NSPreferencesGeneral"]];
    [self addView:self.updatesPreferenceView label:@"Update" image:[NSImage imageNamed:@"UpdateIcon"]];
    
    // Optional configuration settings.
    [self setCrossFade:[[NSUserDefaults standardUserDefaults] boolForKey:@"fade"]];
    [self setShiftSlowsAnimation:[[NSUserDefaults standardUserDefaults] boolForKey:@"shiftSlowsAnimation"]];
}
-(void)showWindow:(id)sender{
    [super showWindow:sender];
    [NSApp activateIgnoringOtherApps:YES];
}

-(void)windowDidBecomeKey:(NSNotification *)notification{
    ProcessSerialNumber psn = { 0, kCurrentProcess };
    TransformProcessType(&psn, kProcessTransformToForegroundApplication);
}

-(void)windowWillClose:(NSNotification *)notification{
    ProcessSerialNumber psn = { 0, kCurrentProcess };
    TransformProcessType(&psn, kProcessTransformToUIElementApplication);
}

@end
