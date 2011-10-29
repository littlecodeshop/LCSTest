//
//  Keyboard.m
//  LittleSynth
//
//  Created by Richard Ribier on 27/10/11.
//  Copyright (c) 2011 LittleCodeShop. All rights reserved.
//

#import "Keyboard.h"

@implementation Keyboard

@synthesize keyboardDelegate;


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    NSSet * alltouches = [event allTouches];
    UITouch *touch =[[alltouches allObjects] objectAtIndex:0];
    CGPoint p = [touch locationInView:self];
    
     NSLog(@"you moooooved !! %f",64.0f+p.x);
    [keyboardDelegate noteOn:64.0+p.x];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"you moooooved !!");
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"the end !!");
   // [keyboardDelegate noteOff];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"ooooops");
}
@end
