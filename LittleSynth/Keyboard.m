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

/*//////////
on gere comme ca :
 quand sur les event -> regarder ou ca se passe,
 si une nouvelle touche est affecté -> faire l'action
 si aucune nouvelle touche affectée -> status quo
 action : 
//////////*/

- (id)initWithCoder:(NSCoder*)aDecoder 
{
    if(self = [super initWithCoder:aDecoder]) 
    {
        // setup the keyboard
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        
        touchesPiano[0].origin.x = 0.0;
        touchesPiano[0].origin.y = 211.0;
        touchesPiano[0].size.width = 60;
        touchesPiano[0].size.height = 109;
        touchesPiano[1].origin.x = 38.0;
        touchesPiano[1].origin.y = 88.0;
        touchesPiano[1].size.width = 40;
        touchesPiano[1].size.height = 123;
        touchesPiano[2].origin.x = 60.0;
        touchesPiano[2].origin.y = 211.0;
        touchesPiano[2].size.width = 60;
        touchesPiano[2].size.height = 109;
        touchesPiano[3].origin.x = 97.0;
        touchesPiano[3].origin.y = 88.0;
        touchesPiano[3].size.width = 40;
        touchesPiano[3].size.height = 123;
        touchesPiano[4].origin.x = 120.0;
        touchesPiano[4].origin.y = 211.0;
        touchesPiano[4].size.width = 60;
        touchesPiano[4].size.height = 109;
        touchesPiano[5].origin.x = 180.0;
        touchesPiano[5].origin.y = 211.0;
        touchesPiano[5].size.width = 60;
        touchesPiano[5].size.height = 109;
        touchesPiano[6].origin.x = 217.0;
        touchesPiano[6].origin.y = 88.0;
        touchesPiano[6].size.width = 40;
        touchesPiano[6].size.height = 123;
        touchesPiano[7].origin.x = 240.0;
        touchesPiano[7].origin.y = 211.0;
        touchesPiano[7].size.width = 60;
        touchesPiano[7].size.height = 109;
        touchesPiano[8].origin.x = 278.0;
        touchesPiano[8].origin.y = 88.0;
        touchesPiano[8].size.width = 40;
        touchesPiano[8].size.height = 123;
        touchesPiano[9].origin.x = 300.0;
        touchesPiano[9].origin.y = 211.0;
        touchesPiano[9].size.width = 60;
        touchesPiano[9].size.height = 109;
        touchesPiano[10].origin.x = 338.0;
        touchesPiano[10].origin.y = 88.0;
        touchesPiano[10].size.width = 40;
        touchesPiano[10].size.height = 123;
        touchesPiano[11].origin.x = 360.0;
        touchesPiano[11].origin.y = 211.0;
        touchesPiano[11].size.width = 60;
        touchesPiano[11].size.height = 109;
        touchesPiano[12].origin.x = 420.0;
        touchesPiano[12].origin.y = 211.0;
        touchesPiano[12].size.width = 60;
        touchesPiano[12].size.height = 109;
        touchesPiano[13].origin.x = 456.0;
        touchesPiano[13].origin.y = 88.0;
        touchesPiano[13].size.width = 40;
        touchesPiano[13].size.height = 123;

    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
	NSEnumerator *e = [touches objectEnumerator];
	UITouch * oneTouch;
    
	while ( (oneTouch = [e nextObject]) ) {
        //il faut regarder dans quelle case est cette touche
        for(int i=0;i<14;i++){
            if(CGRectContainsPoint (touchesPiano[i],[oneTouch locationInView:self])){
                                                    [keyboardDelegate noteOn:48.0f+i];
            }
        }
	}

    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    //if we move from 1 touch to another we need to stop the first and start the new
    NSEnumerator *e = [touches objectEnumerator];
    UITouch * oneTouch;
    int previous,current = 0;

    while ( (oneTouch = [e nextObject]) ) {
        //il faut regarder dans quelle case est cette touche
        for(int i=0;i<14;i++){
            if(CGRectContainsPoint (touchesPiano[i],[oneTouch previousLocationInView:self])){
                //check if we are still on the same place
                if(!CGRectContainsPoint (touchesPiano[i],[oneTouch locationInView:self])){
                    for(int j=0;j<14;j++){
                        if(CGRectContainsPoint (touchesPiano[j],[oneTouch locationInView:self])){
                            //stop the old and start the current
                            [keyboardDelegate noteOff:48.0f+i];
                            [keyboardDelegate noteOn:48.0f+j];
                        }

                    }
                }


            }

        }

    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	NSEnumerator *e = [touches objectEnumerator];
	UITouch * oneTouch;
    
	while ( (oneTouch = [e nextObject]) ) {
        //il faut regarder dans quelle case est cette touche
        for(int i=0;i<14;i++){
            if(CGRectContainsPoint (touchesPiano[i],[oneTouch locationInView:self])){
                                                    [keyboardDelegate noteOff:48.0f+i];
            }
        }
	}
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"ooooops");
}

@end
