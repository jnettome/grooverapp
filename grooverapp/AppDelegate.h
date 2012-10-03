//
//  AppDelegate.h
//  grooverapp
//
//  Created by João Netto on 10/2/12.
//  Copyright (c) 2012 João Netto. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "SPMediaKeyTap.h"

@interface GrooverApp : NSApplication
@end

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    SPMediaKeyTap *keyTap;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet WebView *navigator;

@end
