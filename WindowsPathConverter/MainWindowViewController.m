//
//  MainWindowViewController.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 31/08/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "MainWindowViewController.h"
#import "PathConverter.h"
#import "WindowsPathConverterSettings.h"
#import <MASShortcut/Shortcut.h>

static NSString *const kPreferenceGlobalShortcut = @"GlobalShortcut";

@interface MainWindowViewController ()

@property (weak) IBOutlet MASShortcutView *shortCutView;
@property (strong, nonatomic) PathConverter* pathConverter;

@end

@implementation MainWindowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.input.delegate = self;
    
    self.pathConverter = [[PathConverter alloc] initWithConversionStrings:WindowsPathConverterSettings.sharedSettings.volumes];
    
    // Associate the shortcut view with user defaults
    self.shortCutView.associatedUserDefaultsKey = kPreferenceGlobalShortcut;
    
    // Associate the preference key with an action
    [[MASShortcutBinder sharedBinder]
     bindShortcutWithDefaultsKey:kPreferenceGlobalShortcut
     toAction:^{
         [self toggleWindow];
     }];
    
    [self hideWindow];
    
    [self.window setLevel:NSFloatingWindowLevel];
    self.window.alphaValue = 0.0f;
}

-(void)controlTextDidChange:(NSNotification *)obj
{
    NSString* inputString = self.input.stringValue;
    BOOL isWindowsPath = [self.pathConverter stringIsWindowsPath:inputString];
    self.output.stringValue = isWindowsPath ? [_pathConverter windowsToUnix:inputString] : [_pathConverter unixToWindows:inputString];
}

#pragma mark - Button handler

- (IBAction)copyButtonPressed:(id)sender {
    [self copyStringToClipBoard:self.output.stringValue];
    //    [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
}
- (IBAction)openButtonPressed:(id)sender {
    [self openPath:@[self.output.stringValue, self.input.stringValue]];
}


#pragma mark - Window toggle functions

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

@end
