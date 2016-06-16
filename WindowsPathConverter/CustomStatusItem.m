//
//  CustomStatusItem.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 16/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "CustomStatusItem.h"

@implementation CustomStatusItem

- (void)setHighlightState:(BOOL)state{
    if(self.clicked != state){
        self.clicked = state;
        [self setNeedsDisplay:YES];
    }
}

- (void)drawImage:(NSImage *)aImage centeredInRect:(NSRect)aRect{
    NSRect imageRect = NSMakeRect((CGFloat)round(aRect.size.width*0.5f-aImage.size.width*0.5f),
                                  (CGFloat)round(aRect.size.height*0.5f-aImage.size.height*0.5f),
                                  aImage.size.width,
                                  aImage.size.height);
    [aImage drawInRect:imageRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0f];
}

- (void)drawRect:(NSRect)rect{
    if(self.clicked){
        [[NSColor selectedMenuItemColor] set];
        NSRectFill(rect);
        if(self.altImage){
            [self drawImage:self.altImage centeredInRect:rect];
        }else if(self.image){
            [self drawImage:self.image centeredInRect:rect];
        }
    }else if(self.image){
        [self drawImage:self.image centeredInRect:rect];
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
