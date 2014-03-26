//
//  StreamDelegate.h
//  ShareAmI
//
//  Created by William Katz on 3/10/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPP.h"


@interface StreamDelegate : NSObject < XMPPStreamDelegate > {
   
}

@property XMPPStream* xmppStream;

-(void) setupStream;

@end
