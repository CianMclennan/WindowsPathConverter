//
//  CustomStatusItem.h
//  WindowsPathConverter
//
//  Created by Cian McLennan on 16/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CustomStatusItem : NSView

@property (strong, nonatomic) NSImage* image;
@property (strong, nonatomic) NSImage* altImage;
@property (assign, nonatomic) BOOL clicked;
@property (assign, nonatomic) SEL action;
@property (assign, nonatomic) SEL rightAction;
@property (weak, nonatomic) id target;

- (void)setHighlightState:(BOOL)state;

@end
