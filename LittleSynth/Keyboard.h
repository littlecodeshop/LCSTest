//
//  Keyboard.h
//  LittleSynth
//
//  Created by Richard Ribier on 27/10/11.
//  Copyright (c) 2011 LittleCodeShop. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyboardDelegate <NSObject>
-(void)noteOn:(float)f;
-(void)noteOff:(float)f;
@end 


@interface Keyboard : UIImageView
{

    __weak IBOutlet id<KeyboardDelegate> keyboardDelegate;  

}

@property (weak) id keyboardDelegate;

@end


