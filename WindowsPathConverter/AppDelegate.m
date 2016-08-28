//
//  AppDelegate.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 25/04/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "AppDelegate.h"
#import "PathConverter.h"
#import "FileReadWriter.h"
#import "CustomStatusItem.h"
#import "FloatingWindow.h"
#import <AppKit/AppKit.h>
#import <MASShortcut/Shortcut.h>
#import "WindowsPathConverterSettings.h"

@interface AppDelegate ()

@property (weak) IBOutlet MASShortcutView *shortCutView;
@property (weak) IBOutlet FloatingWindow* window;
@property (strong, nonatomic) NSStatusItem* statusItem;
@property (strong, nonatomic) NSMenu* statusMenu;

@property (strong, nonatomic) PathConverter* pathConverter;

@end

static NSString *const kPreferenceGlobalShortcut = @"GlobalShortcut";

@implementation AppDelegate

#pragma mark - App Delegate Methods
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.input.delegate = self;
    
    self.pathConverter = [[PathConverter alloc] initWithConversionStrings:WindowsPathConverterSettings.sharedSettings.windowsDrives];
    
    [self.window setLevel:NSFloatingWindowLevel];
    self.window.delegate = self;
    self.statusItem = [self createStatusBarButton];
    self.statusMenu = [self createStatusMenu];
    
    // Associate the shortcut view with user defaults
    self.shortCutView.associatedUserDefaultsKey = kPreferenceGlobalShortcut;
    
    // Associate the preference key with an action
    [[MASShortcutBinder sharedBinder]
     bindShortcutWithDefaultsKey:kPreferenceGlobalShortcut
     toAction:^{
         [self toggleWindow];
     }];
    self.window.alphaValue = 0.0f;
    [self hideWindow];
}
-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [self displayWindow];
    return YES;
}

#pragma mark - Main Window Methods

-(void)controlTextDidChange:(NSNotification *)obj
{
    NSString* inputString = self.input.stringValue;
    BOOL isWindowsPath = [_pathConverter stringIsWindowsPath:inputString];
    self.output.stringValue = isWindowsPath ? [_pathConverter windowsToUnix:inputString] : [_pathConverter unixToWindows:inputString];
}

- (IBAction)copyButtonPressed:(id)sender {
    [self copyStringToClipBoard:self.output.stringValue];
//    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
}
- (IBAction)openButtonPressed:(id)sender {
    [self openPath:@[self.output.stringValue, self.input.stringValue]];
}

#pragma mark - Helper Methods

-(void) openPath:(NSArray*) paths{
    NSPipe *pipe = [NSPipe pipe];
    NSFileHandle *file = pipe.fileHandleForReading;
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/open";
    task.arguments = @[paths.firstObject];
    task.standardOutput = pipe;
    
    [task launch];
    
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    NSString *output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    if(!output.length && paths.count>1) {
        NSUInteger newArrayLength = paths.count-1;
        [self openPath:[paths subarrayWithRange:NSMakeRange(1, newArrayLength)]];
    }
}

-(void)copyStringToClipBoard:(NSString*) string
{
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    [pasteBoard setString: string forType:NSStringPboardType];
}

- (NSURL *)applicationDocumentsDirectory {
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory
                                                                   inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"WindowsPathConverter"];
}

#pragma mark - Status Bar Button Code

-(NSStatusItem*) createStatusBarButton
{
    CustomStatusItem* statusView = [[CustomStatusItem alloc] init];
    statusView.image = [NSImage imageNamed:@"toolbarIcon"];
    statusView.target = self;
    statusView.action = @selector(statusItemClicked:);
    statusView.rightAction = @selector(statusItemSecondaryClicked:);
    
    NSStatusItem* statusBarItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
    statusBarItem.view = statusView;
    return statusBarItem;
}
-(NSMenu*) createStatusMenu{
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Open" action:@selector(statusItemClicked:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Prefrences..." action:@selector(openPrefrences:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    menu.delegate = self;
    return menu;
}

-(void) openPrefrences: (id) sender {
    [self.prefrencesWindow makeKeyAndOrderFront:self];
}
-(void)windowDidResignKey:(NSNotification *)notification{
    [self hideWindow];
}
-(void)windowDidResignMain:(NSNotification *)notification{
    [self hideWindow];
}

-(void)statusItemClicked: (id) sender{
    [self toggleWindow];
    [(CustomStatusItem*)self.statusItem.view setHighlightState:NO];
}

-(void) toggleWindow{
    self.window.alphaValue ? [self hideWindow] : [self displayWindow];
}
-(void) displayWindow
{
    [self.window makeKeyAndOrderFront:self];
    [NSApp activateIgnoringOtherApps:YES];
    self.window.alphaValue = 0.0f;
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:0.1f];
    [[self.window animator] setAlphaValue:1.0f];
    [NSAnimationContext endGrouping];
    [self.input becomeFirstResponder];
}
-(void) hideWindow{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [self.window close];
    }];
    [[NSAnimationContext currentContext] setDuration:0.1f];
    [[self.window animator] setAlphaValue:0.0f];
    [NSAnimationContext endGrouping];
}
-(void)statusItemSecondaryClicked: (id) sender{
    [self.statusItem popUpStatusItemMenu:self.statusMenu];
}
- (void)menuDidClose:(NSMenu *)menu{
    [(CustomStatusItem*)self.statusItem.view setHighlightState:NO];
}

@end
