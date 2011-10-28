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
    NSLog(@"touches begins !!");
    [keyboardDelegate play];
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"you moooooved !!");
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"the end !!");
    [keyboardDelegate up];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"ooooops");
}
@end
