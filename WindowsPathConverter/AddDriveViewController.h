//
//  AddDriveViewController.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 28/08/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AddDriveViewController : NSViewController

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *windowsPath;
@property (weak) IBOutlet NSTextField *macPath;

- (IBAction)addButton:(NSButton *)sender;
- (IBAction)cancelButton:(NSButton *)sender;

@end
