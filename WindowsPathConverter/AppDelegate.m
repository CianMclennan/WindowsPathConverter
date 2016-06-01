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
    _pathConverter = self.settings[@"windows_drives"];
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

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)copyToClipboard:(id)sender {
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
    [pasteBoard setString: self.output.stringValue forType:NSStringPboardType];
}

-(NSDictionary*)settings
{
    NSDictionary* settings = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *applicationDocumentsDirectory = [self applicationDocumentsDirectory];
    NSURL *settingsFile = [applicationDocumentsDirectory URLByAppendingPathComponent:@"settings.json" isDirectory:NO];
    NSString* contentOfFile = nil;
    if(![fileManager fileExistsAtPath:settingsFile.path]) {
        NSURL* defaultSettings = [[NSBundle mainBundle] URLForResource:@"settings" withExtension:@"json" subdirectory:nil localization:nil];
        contentOfFile = [FileReadWriter readTextFromURL:defaultSettings];
        [FileReadWriter writeText:contentOfFile toFile:settingsFile];
    }
    if(!contentOfFile) contentOfFile = [FileReadWriter readTextFromURL:settingsFile];
    NSError *error;
    settings = [NSJSONSerialization JSONObjectWithData:[contentOfFile dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    return settings;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ciankm.Forecast" in the user's Application Support directory.
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
#ifdef DEBUG
    return [appSupportURL URLByAppendingPathComponent:@"WindowsPathConverter"];
#else
    return [appSupportURL URLByAppendingPathComponent:@"WindowsPathConverter_DEBUG"];
#endif
}
@end
