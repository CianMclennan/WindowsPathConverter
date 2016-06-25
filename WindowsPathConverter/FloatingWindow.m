//
//  FloatingWindow.m
//  WindowsPathConverter
//
//  Created by Cian McLennan on 25/06/2016.
//  Copyright © 2016 Cian McLennan. All rights reserved.
//

#import "FloatingWindow.h"

@implementation FloatingWindow

-(BOOL)canBecomeKeyWindow{
    return YES;
}
-(BOOL)canBecomeMainWindow{
    return YES;
}

@end
