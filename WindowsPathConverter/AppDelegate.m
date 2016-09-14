//
//  AppDelegate.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 25/04/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "AppDelegate.h"

#import "FileReadWriter.h"
#import "FloatingWindow.h"
#import <AppKit/AppKit.h>
#import <MASShortcut/Shortcut.h>
#import "WindowsPathConverterSettings.h"
#import "PrefrencesWindowController.h"

#import "constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    NSStatusItem* _statusBarButton;
    NSMenu* _statusMenu;
}

#pragma mark - App Delegate Methods
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if (WindowsPathConverterSettings.sharedSettings.shouldOpenPreferencesOnStartup){
        [[PrefrencesWindowController sharedPrefsWindowController] showWindow:nil];
    }
    // Associate the preference key with an action
    [[MASShortcutBinder sharedBinder]
     bindShortcutWithDefaultsKey:kPreferenceGlobalShortcut
     toAction:^{
         [[NSNotificationCenter defaultCenter] postNotificationName:STATUS_ITEM_CLICKED
                                                             object:nil];
     }];
    
    // Add status bar butotn to the status bar.
    [self statusBarButton];
}
-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag {
    return YES;
}

#pragma mark - Status Bar Button Code

-(NSStatusItem*) statusBarButton
{
    if (_statusBarButton) return _statusBarButton;
    StatusItem* statusItem = self.statusButton;
    statusItem.image.image.template = YES;
    statusItem.action = @selector(statusItemClicked:);
    statusItem.rightAction = @selector(statusItemSecondaryClicked:);
    _statusBarButton = [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
    _statusBarButton.view = statusItem;
    return _statusBarButton;
}

-(NSMenu*) statusMenu{
    if (_statusMenu) return _statusMenu;
    _statusMenu = [[NSMenu alloc] init];
    [_statusMenu addItemWithTitle:@"Open" action:@selector(statusItemClicked:) keyEquivalent:@""];
    [_statusMenu addItemWithTitle:@"Prefrences..." action:@selector(openPrefrences:) keyEquivalent:@""];
    [_statusMenu addItemWithTitle:@"Check for Updates..." action:@selector(updateApplication:) keyEquivalent:@""];
    [_statusMenu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    _statusMenu.delegate = self;
    return _statusMenu;
}

#pragma mark - selector methods

-(void) updateApplication: (id) sender
{
    [self.updater checkForUpdates:sender];
}
-(void) openPrefrences: (id) sender {
    [[PrefrencesWindowController sharedPrefsWindowController] showWindow:nil];
}

-(void)statusItemClicked: (id) sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:STATUS_ITEM_CLICKED
                                                        object:nil];
    [(StatusItem*)self.statusBarButton.view setHighlightState:NO];
}

-(void)statusItemSecondaryClicked: (id) sender{
    [self.statusBarButton popUpStatusItemMenu:self.statusMenu];
}
- (void)menuDidClose:(NSMenu *)menu{
    [(StatusItem*)self.statusBarButton.view setHighlightState:NO];
}

@end
