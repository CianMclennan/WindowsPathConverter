//
//  StatusItem.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 14/09/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface StatusItem : NSView

@property (weak) IBOutlet NSImageView *image;

@property (assign, nonatomic) BOOL clicked;
@property (assign, nonatomic) SEL action;
@property (assign, nonatomic) SEL rightAction;
@property (weak) IBOutlet id target;

- (void)setHighlightState:(BOOL)state;

@end
