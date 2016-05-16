//
//  AppDelegate.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 25/04/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate>

@property (weak) IBOutlet NSTextField *output;
@property (weak) IBOutlet NSTextField *input;

- (IBAction)copyToClipboard:(id)sender;

@end

