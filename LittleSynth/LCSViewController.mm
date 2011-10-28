//
//  LCSViewController.m
//  LittleSynth
//
//  Created by Richard Ribier on 27/10/11.
//  Copyright (c) 2011 LittleCodeShop. All rights reserved.
//

#import "LCSViewController.h"

@implementation LCSViewController

@synthesize keyboard, queue, synthOperation;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void) initSTKInstr{
    

    
    NSString *dir = [[NSBundle mainBundle] resourcePath]; 
    Stk::setSampleRate( 44100.0 );
    Stk::setRawwavePath([dir UTF8String]  );
    //Stk::showWarnings( true );//TODO: remove that in real life
    
    tdata.voix = (Instrmnt**)malloc(NUMBER_INSTRUMENT*sizeof(Instrmnt));
    
    tdata.voicer = new Voicer();
    for(int i=0;i<NUMBER_INSTRUMENT;i++){
        tdata.voix[i]=(Instrmnt*)new Plucked(64.0);  
        tdata.voicer->addInstrument(tdata.voix[i],i); 
    }
    
    
    //start the thread
    queue = [[NSOperationQueue alloc] init];
	LCSVIOperation * op = [[LCSVIOperation alloc] initWithSTKData:&tdata];
	self.synthOperation = op; 
	[queue addOperation:op];

    
}


-(void)play{
	tdata.voicer->noteOn(64.0f, 64.0f, 0);
}

-(void)up{
    tdata.voicer->noteOff(64.0f,64.0f,0);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //create the voicer and stuff
    [self initSTKInstr];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
