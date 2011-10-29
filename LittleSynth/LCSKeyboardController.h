//
//  LCSViewController.h
//  LittleSynth
//
//  Created by Richard Ribier on 27/10/11.
//  Copyright (c) 2011 LittleCodeShop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stk.h"
#import "Voicer.h"
#import "Keyboard.h"
#import "LCSVIOperation.h"
#import "Messager.h"

#define POLYPHONIE 10

@interface LCSKeyboardController : UIViewController
{
    Keyboard * keyboard;
    TickData tdata;
    NSOperationQueue *queue;
    LCSVIOperation * synthOperation;
}

@property (nonatomic,retain) Keyboard * keyboard;
@property (nonatomic,retain) NSOperationQueue * queue;
@property (nonatomic,retain) LCSVIOperation * synthOperation;



@end
