//
//  PrefrencesWindowController.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 11/09/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import <DBPrefsWindowController/DBPrefsWindowController.h>

@interface PrefrencesWindowController : DBPrefsWindowController

@property (strong, nonatomic) IBOutlet NSView *generalPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *updatesPreferenceView;
@property (strong, nonatomic) IBOutlet NSView *drivesPreferenceView;

@end
