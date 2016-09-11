//
//  AppDelegate.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 25/04/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "AppDelegate.h"

#import "FileReadWriter.h"
#import "CustomStatusItem.h"
#import "FloatingWindow.h"
#import <AppKit/AppKit.h>
#import "WindowsPathConverterSettings.h"

#import "constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate{
    NSStatusItem* _statusBarButton;
    NSMenu* _statusMenu;
}

#pragma mark - App Delegate Methods
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    if (WindowsPathConverterSettings.sharedSettings.isFirstLaunch){
        [self.prefrencesWindow makeKeyAndOrderFront:self];
        WindowsPathConverterSettings.sharedSettings.isFirstLaunch = NO;
    }
    
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
    CustomStatusItem* statusView = [[CustomStatusItem alloc] init];
    statusView.image = [NSImage imageNamed:@"toolbarIcon"];
    statusView.target = self;
    statusView.action = @selector(statusItemClicked:);
    statusView.rightAction = @selector(statusItemSecondaryClicked:);
    
    _statusBarButton = [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
    _statusBarButton.view = statusView;
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
    [self.prefrencesWindow makeKeyAndOrderFront:self];
}

-(void)statusItemClicked: (id) sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:STATUS_ITEM_CLICKED
                                                        object:nil];
    [(CustomStatusItem*)self.statusBarButton.view setHighlightState:NO];
}

-(void)statusItemSecondaryClicked: (id) sender{
    [self.statusBarButton popUpStatusItemMenu:self.statusMenu];
}
- (void)menuDidClose:(NSMenu *)menu{
    [(CustomStatusItem*)self.statusBarButton.view setHighlightState:NO];
}

@end
