//
//  PrefrencesViewController.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 28/08/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <MASShortcut/Shortcut.h>
#import "AddDriveViewController.h"

@interface PrefrencesViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSWindow *modalWindow;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet MASShortcutView *shortCutView;
@property (weak) IBOutlet NSButton *shouldOpenOnStart;

- (IBAction)addButtonPressed:(NSButton *)sender;
- (IBAction)subtractButtonPressed:(NSButton *)sender;
- (IBAction)showPreferencesToggle:(NSButton *)sender;

@end
