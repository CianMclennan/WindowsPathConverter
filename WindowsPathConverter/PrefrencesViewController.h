//
//  PrefrencesViewController.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 28/08/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PrefrencesViewController : NSViewController <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;

- (IBAction)addButtonPressed:(NSButton *)sender;
- (IBAction)subtractButtonPressed:(NSButton *)sender;



@end
