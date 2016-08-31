//
//  MainWindowViewController.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 31/08/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindowViewController : NSViewController <NSWindowDelegate>
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *output;
@property (weak) IBOutlet NSTextField *input;

- (IBAction)copyButtonPressed:(id)sender;
- (IBAction)openButtonPressed:(id)sender;

@end
