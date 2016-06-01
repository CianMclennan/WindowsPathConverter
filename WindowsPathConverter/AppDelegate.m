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

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate
{
    PathConverter* _pathConverter;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.input.delegate = self;
    _pathConverter = [[PathConverter alloc] initWithConversionStrings:self.settings[@"windows_drives"]];
}
-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [self.window makeKeyAndOrderFront:self];
    return YES;
}

-(void)controlTextDidChange:(NSNotification *)obj
{
    NSString* inputString = self.input.stringValue;
    BOOL isWindowsPath = [_pathConverter stringIsWindowsPath:inputString];
    self.output.stringValue = isWindowsPath ? [_pathConverter windowsToUnix:inputString] : [_pathConverter unixToWindows:inputString];
}

- (IBAction)copyToClipboard:(id)sender {
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    [pasteBoard setString: self.output.stringValue forType:NSStringPboardType];
}

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

- (NSURL *)applicationDocumentsDirectory {
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory
                                                                   inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"WindowsPathConverter"];
}
@end
