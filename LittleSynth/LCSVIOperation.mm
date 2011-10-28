//
//  LCSVIOperation.m
//  MultiTrack
//
//  Created by Richard Ribier on 23/01/09.
//  Copyright 2009 LittleCodeShop. All rights reserved.
//

#import "LCSVIOperation.h"


#pragma mark -
#pragma mark Audio Callback called when there is a new data to put in the output

static void AQBufferCallback(void *in,	AudioQueueRef inQ, AudioQueueBufferRef outQB)
{
	int i;
	UInt32 err;
	float floatVal;
	short sampleValue; // -32767 bis +32767
	
	// Zuweisung der Struktur und des Zeigers für den Output uffer
	AQCallbackStruct *inData = (AQCallbackStruct *)in;
	short *coreAudioBuffer = (short*) outQB->mAudioData;
	
	// so lange frameCount > 0 ist ist, haben wir auch Daten zum verarbeiten
	if (inData->frameCount > 0) {
		// Zuweisen der Größe des Buffers
		outQB->mAudioDataByteSize = 4*inData->frameCount; // zwei shorts pro sample * 2 Kanäle
		
		// Für jedes Sample pro Kanal
		for(i=0; i<inData->frameCount*2; i=i+2) {
			// Berechnen der Sinuskurve
			//floatVal = input.tick();//sin(((float)sampleNr * 2.0 * M_PI * 440.0) / 44100.0); // Kammerton A
			//floatVal = sin(((float)sampleNr * 2.0 * M_PI * 440.0) / 44100.0); // Kammerton A
			//floatVal = data.instrument->tick();
			floatVal = inData->data->voicer->tick();
			
			sampleValue = (int)(floatVal * 32767.0f);
			coreAudioBuffer[i] = sampleValue; // Linker Kanal
			coreAudioBuffer[i+1] = sampleValue; // Rechter Kanal
			
		}
		// Buffer entleeren (Wasser des Eimers ins Feuer kippen)
		AudioQueueEnqueueBuffer(inQ, outQB, 0, NULL);
	} else {
		err = AudioQueueStop(inData->queue, false);
		NSLog(@"Queue is beeing stopped");
	}
}



AQCallbackStruct in; 





@implementation LCSVIOperation


-(id) initWithSTKData:(TickData*) tdata{
	
	if(![super init]) return nil;
	
	in.data = tdata;
	in.mDataFormat.mSampleRate = 44100.0;
	in.mDataFormat.mFormatID = kAudioFormatLinearPCM;
	in.mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
	in.mDataFormat.mBytesPerPacket = 4;
	in.mDataFormat.mFramesPerPacket = 1;
	in.mDataFormat.mBytesPerFrame = 4;
	in.mDataFormat.mChannelsPerFrame = 2;
	in.mDataFormat.mBitsPerChannel = 16;
	in.frameCount = 1024;
	
	UInt32 err = AudioQueueNewOutput(&in.mDataFormat, AQBufferCallback, &in, /*CFRunLoopGetCurrent()*/nil, kCFRunLoopCommonModes, 0, &in.queue);
	UInt32 bufferBytes = in.frameCount * in.mDataFormat.mBytesPerFrame;
	
	// alloc 3 buffers.
	for (int i=0; i< NUM_BUFFERS; i++) {
		err = AudioQueueAllocateBuffer(in.queue, bufferBytes, &in.mBuffers[i]);
		if(err) fprintf(stderr, "AudioQueueAllocateBuffer [%d] err %lu\n",i, err);
		// Erster initialer Aufruf der Callback Funktion
		AQBufferCallback (&in, in.queue, in.mBuffers[i]);
	}	
	
	// Einstellung der Lautstärke
	err = AudioQueueSetParameter(in.queue, kAudioQueueParam_Volume, 1.0);
	if(err) fprintf(stderr, "AudioQueueSetParameter err %lu\n", err);
	
		
	
	return self;
	
}

-(AudioQueueRef)getAudioIn{

	return in.queue;
}

-(void) main{

	BOOL done = NO;
	UInt32 err =  AudioQueueStart(in.queue, NULL);
	if(err) fprintf(stderr, "AudioQueueStart err %lu\n", err);

	
	
	while(!done){
	
	//ici on maintient la thread ouverte tant qu'il faut
	//check if we have to die
		if([self isCancelled] ){ 
		done = YES;
			AudioQueueStop(in.queue, YES);
			
		
		}
		usleep(10000);
		
	
	}
	
}

@end
