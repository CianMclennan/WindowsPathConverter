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
#import <AppKit/AppKit.h>

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow* window;
@property (strong, nonatomic) NSStatusItem* statusItem;
@property (strong, nonatomic) NSMenu* statusMenu;
@end

@implementation AppDelegate
{
    PathConverter* _pathConverter;
}

#pragma mark - App Delegate Methods
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.input.delegate = self;
    _pathConverter = [[PathConverter alloc] initWithConversionStrings:self.settings[@"windows_drives"]];
    [self.window setLevel:NSFloatingWindowLevel];
    self.window.delegate = self;
    self.statusItem = [self createStatusBarButton];
    self.statusMenu = [self createStatusMenu];
}
-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [self.window makeKeyAndOrderFront:self];
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
}
- (IBAction)openButtonPressed:(id)sender {
    [self openPath:@[self.output.stringValue, self.input.stringValue]];
}
-(void)windowDidResignKey:(NSNotification *)notification{
    [self.window close];
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

#pragma mark - Settings Getter

-(NSDictionary*)settings
{
    NSDictionary* settings = nil;
    NSString* contentOfFile = nil;
    
    NSURL *settingsFile = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"settings.json"
                                                                                isDirectory:NO];
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:settingsFile.path]) {
        NSURL* defaultSettings = [[NSBundle mainBundle] URLForResource:@"settings"
                                                         withExtension:@"json"
                                                          subdirectory:nil
                                                          localization:nil];
        contentOfFile = [FileReadWriter readTextFromURL:defaultSettings];
        [FileReadWriter writeText:contentOfFile toFile:settingsFile];
    }
    
    if(!contentOfFile) contentOfFile = [FileReadWriter readTextFromURL:settingsFile];
    NSError *error;
    settings = [NSJSONSerialization JSONObjectWithData:[contentOfFile dataUsingEncoding:NSUTF8StringEncoding]
                                               options:0
                                                 error:&error];
    return settings;
}

#pragma mark - Status Bar Button Code

-(NSStatusItem*) createStatusBarButton
{
    CustomStatusItem* statusView = [[CustomStatusItem alloc] init];
    statusView.image = [NSImage imageNamed:@"bat23"];
    statusView.target = self;
    statusView.action = @selector(statusItemClicked:);
    statusView.rightAction = @selector(statusItemSecondaryClicked:);
    
    NSStatusItem* statusBarItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSSquareStatusItemLength];
    statusBarItem.view = statusView;
    return statusBarItem;
}
-(NSMenu*) createStatusMenu{
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
    menu.delegate = self;
    return menu;
}

-(void)statusItemClicked: (NSStatusItem*) sender{
    [self.window makeKeyAndOrderFront:self];
    [(CustomStatusItem*)self.statusItem.view setHighlightState:NO];
}
-(void)statusItemSecondaryClicked: (NSStatusItem*) sender{
    [self.statusItem popUpStatusItemMenu:self.statusMenu];
}
- (void)menuDidClose:(NSMenu *)menu{
    [(CustomStatusItem*)self.statusItem.view setHighlightState:NO];
}

@end
