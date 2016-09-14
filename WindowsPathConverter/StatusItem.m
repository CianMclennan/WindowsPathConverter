//
//  StatusItem.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 14/09/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "StatusItem.h"

@implementation StatusItem

- (void)setHighlightState:(BOOL)state{
        self.clicked = state;
        [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect{
    if(self.clicked){
        [[NSColor selectedMenuItemColor] set];
        NSRectFill(rect);
    }
}

- (void)mouseDown:(NSEvent *)theEvent{
    [super mouseDown:theEvent];
    [self setHighlightState:!self.clicked];
    if ([theEvent modifierFlags] & NSCommandKeyMask){
        [self.target performSelectorOnMainThread:self.rightAction withObject:nil waitUntilDone:NO];
    }else{
        [self.target performSelectorOnMainThread:self.action withObject:nil waitUntilDone:NO];
    }
}

- (void)rightMouseDown:(NSEvent *)theEvent{
    [super rightMouseDown:theEvent];
    [self setHighlightState:!self.clicked];
    [self.target performSelectorOnMainThread:self.rightAction withObject:nil waitUntilDone:NO];
}

@end
