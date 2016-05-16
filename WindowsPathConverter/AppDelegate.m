//
//  AppDelegate.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 25/04/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "AppDelegate.h"

#define PRODUCTION_WINDOWS @"P:"
#define PRODUCTION_MAC @"/Volumes/production"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate
{
    NSDictionary* windowsDriveSetup;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.input.delegate = self;
    self.settings;
}
-(BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [self.window makeKeyAndOrderFront:self];
    return YES;
}

-(void)controlTextDidChange:(NSNotification *)obj
{
    self.output.stringValue = [self currentInputIsWindowsString] ? [self windowsToUnix:self.input.stringValue] : [self unixToWindows:self.input.stringValue];
}

-(BOOL) currentInputIsWindowsString
{
    NSString* input = self.input.stringValue;
    return [input containsString:PRODUCTION_WINDOWS] || [[input substringToIndex:1] isEqualToString:@"\\"];
}

-(NSString*) windowsToUnix:(NSString*) windowsString
{
    NSString* unixString = [windowsString stringByReplacingOccurrencesOfString:PRODUCTION_WINDOWS withString:PRODUCTION_MAC];
    unixString = [unixString stringByReplacingOccurrencesOfString:@"\\" withString: @"/"];
    return unixString;
}

-(NSString*) unixToWindows:(NSString*) unixString
{
    NSString* windowsString = [unixString stringByReplacingOccurrencesOfString:PRODUCTION_MAC withString:PRODUCTION_WINDOWS];
    windowsString = [windowsString stringByReplacingOccurrencesOfString:@"/" withString:@"\\"];
    return windowsString;
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
    if(![fileManager fileExistsAtPath:[settingsFile absoluteString]])
    {
        NSError* error;
        NSString* defaultSettings = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"json"];
        NSString* destination = [[applicationDocumentsDirectory URLByAppendingPathComponent:@"settings.json"] absoluteString];
        
        
        [fileManager copyItemAtPath:defaultSettings toPath:destination error:&error];
//        [fileManager copyItemAtURL:defaultSettings toURL:destination error:&error];
        if (error) @throw [NSException exceptionWithName:@"SettingsException" reason:[error description] userInfo:nil];
    }
    
    
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
