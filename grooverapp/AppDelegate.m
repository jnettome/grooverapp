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
    [navigator setFrameLoadDelegate:self];
    [navigator setCustomUserAgent: @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; en-us) AppleWebKit/533.19.4 (KHTML, like Gecko) Version/5.0.3 Safari/533.19.4"];
    
    NSURL* url = [NSURL URLWithString:@"http://grooveshark.com"];
    [[navigator mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
    
    keyTap = [[SPMediaKeyTap alloc] initWithDelegate:self];
    if([SPMediaKeyTap usesGlobalMediaKeyTap])
        [keyTap startWatchingMediaKeys];
}

-(void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    [navigator stringByEvaluatingJavaScriptFromString:@"document.getElementById('lightbox_close').click();"];
}

-(void)mediaKeyTap:(SPMediaKeyTap *)keyTap receivedMediaKeyEvent:(NSEvent *)event;
{
	int keyCode = (([event data1] & 0xFFFF0000) >> 16);
	int keyFlags = ([event data1] & 0x0000FFFF);
	BOOL keyIsPressed = (((keyFlags & 0xFF00) >> 8)) == 0xA;
    
	if (keyIsPressed) {
		switch (keyCode) {
			case NX_KEYTYPE_PLAY:
                [navigator stringByEvaluatingJavaScriptFromString:@"document.getElementById('play-pause').click();"];
				break;
                
			case NX_KEYTYPE_FAST:
                [navigator stringByEvaluatingJavaScriptFromString:@"document.getElementById('play-next').click();"];
                [self notificateUser];
				break;
                
			case NX_KEYTYPE_REWIND:
                [navigator stringByEvaluatingJavaScriptFromString:@"document.getElementById('play-prev').click();"];
                [self notificateUser];
				break;
		}
	}
}

-(void)notificateUser;
{
    if(NSClassFromString(@"NSUserNotification"))
    {
        NSString *musicName = [navigator stringByEvaluatingJavaScriptFromString:@"document.querySelector('.now-playing-link.song').innerHTML;"];
        NSString *musicAuthor = [navigator stringByEvaluatingJavaScriptFromString:@"document.querySelector('.now-playing-link.artist').innerHTML;"];
        NSString *musicAlbum = [navigator stringByEvaluatingJavaScriptFromString:@"document.querySelector('.now-playing-link.album').innerHTML;"];
        
        NSUserNotification *notification = [NSUserNotification new];
        notification.hasActionButton = NO;
        notification.title = musicName;
        notification.informativeText = [NSString stringWithFormat:@"by %@\nin %@", musicAuthor, musicAlbum];
        [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];
    }
}

-(void) dealloc {
    [navigator dealloc];
    [window dealloc];
    [super dealloc];
}

@end
