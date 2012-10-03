//
//  AppDelegate.m
//  grooverapp
//
//  Created by João Netto on 10/2/12.
//  Copyright (c) 2012 João Netto. All rights reserved.
//

#import "AppDelegate.h"

@implementation GrooverApp
- (void)sendEvent:(NSEvent *)theEvent
{
    BOOL shouldHandleMediaKeyEventLocally = ![SPMediaKeyTap usesGlobalMediaKeyTap];
    if(shouldHandleMediaKeyEventLocally && [theEvent type] == NSSystemDefined && [theEvent subtype] == SPSystemDefinedEventMediaKeys)
    {
        [(id)[self delegate] mediaKeyTap:nil receivedMediaKeyEvent:theEvent];
    }
}
@end

@implementation AppDelegate

@synthesize window;
@synthesize navigator;

+(void)initialize;
{
    if([self class] != [AppDelegate class]) return;
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [SPMediaKeyTap defaultMediaKeyUserBundleIdentifiers], kMediaKeyUsingBundleIdentifiersDefaultsKey, nil]];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSURL* url = [NSURL URLWithString:@"http://grooveshark.com"];
    [[navigator mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
    
    keyTap = [[SPMediaKeyTap alloc] initWithDelegate:self];
    if([SPMediaKeyTap usesGlobalMediaKeyTap])
        [keyTap startWatchingMediaKeys];
    else
        NSLog(@"Media key monitoring disabled");
}

-(void)mediaKeyTap:(SPMediaKeyTap *)keyTap receivedMediaKeyEvent:(NSEvent *)event;
{
    NSAssert([event type] == NSSystemDefined && [event subtype] == SPSystemDefinedEventMediaKeys, @"Unexpected NSEvent in mediaKeyTap:receivedMediaKeyEvent:");
    // here be dragons...
	int keyCode = (([event data1] & 0xFFFF0000) >> 16);
	int keyFlags = ([event data1] & 0x0000FFFF);
	BOOL keyIsPressed = (((keyFlags & 0xFF00) >> 8)) == 0xA;
    
	if (keyIsPressed) {
		switch (keyCode) {
			case NX_KEYTYPE_PLAY:
				NSLog(@"Play/Pause pressionada");
				break;
                
			case NX_KEYTYPE_FAST:
                NSLog(@"Proxima pressionada");
				break;
                
			case NX_KEYTYPE_REWIND:
                NSLog(@"Anterior pressionada");
				break;
		}
	}
}

@end
