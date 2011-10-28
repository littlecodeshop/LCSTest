//
//  LCSVIOperation.h
//  MultiTrack
//
//  Created by Richard Ribier on 23/01/09.
//  Copyright 2009 LittleCodeShop. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <AudioToolbox/AudioToolbox.h>

#include "FileRead.h"
#include "FileWrite.h"
#include "FileWvIn.h"
#include "FileWvOut.h"
#include "WvIn.h"
#include "WvOut.h"
#include "WaveLoop.h"
#include "Stk.h"
#include "Simple.h"


#include "Instrmnt.h"
#include "BeeThree.h"
#include "Plucked.h"
#include "Rhodey.h"
#include "Drummer.h"
#include "Voicer.h"

//trucs pour messager
#include "Messager.h"
#include "SKINIMSG.h"

struct TickData {
	Instrmnt **voix;
	Voicer  *voicer; 
	StkFloat frequency;
	StkFloat scaler;
	long counter;
	bool done;
	
	
	//ici je rajoute le messager au cas ou on play
	Messager * messager;
	Skini::Message message;
	
	bool haveMessage;
	
	
	// Default constructor.
	TickData()
    : voicer(), scaler(1.0), counter(0), done( false ) {}
};



#define NUM_BUFFERS 3
typedef struct AQCallbackStruct {
	AudioQueueRef					queue;
	UInt32						frameCount;
	AudioQueueBufferRef			mBuffers[NUM_BUFFERS];
	AudioStreamBasicDescription		mDataFormat;
	struct TickData * data;
} AQCallbackStruct;




@interface LCSVIOperation : NSOperation {

	
	
}

-(id) initWithSTKData:(TickData*) tdata;
-(AudioQueueRef)getAudioIn;

@end
