//
//  StreamDelegate.m
//  ShareAmI
//
//  Created by William Katz on 3/10/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import "StreamDelegate.h"

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@implementation StreamDelegate
{

}


-(void) setupStream {
    //set up the stream
    _xmppStream = [[XMPPStream alloc] init];
    [_xmppStream setHostName:@"William-Katzs-MacBook-Pro-2.local"];
    [_xmppStream setHostPort:5222];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSString* domain = @"williamkatz.local";
    [_xmppStream setMyJID:[XMPPJID jidWithString: [NSString stringWithFormat:@"example2@%@", domain] ]];
    NSError *error;
//    while ( [_xmppStream secureConnection:&error]) {
//        
//    }

    [_xmppStream connectWithTimeout: XMPPStreamTimeoutNone error: &error];
    NSLog (@"%@", error);
    //need username password
    
}

-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"%@",error);
}

- (void)xmppStreamWillConnect:(XMPPStream *)sender{
    //maybe use if I want to indicate this will run in background
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    //safe to begin communication with server
    NSError *error;
    [_xmppStream authenticateWithPassword:@"butterbee"  error:&error];
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    //registering
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    //pretty obvious
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    //did authenticate
    NSLog(@"success");
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error{
    //did not, show error?
    NSLog(@"failure cause %@", error);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error{
    //error when sending
    NSLog(@"%@",error);
}

- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq{
    
}
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    
}
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence{
    
}
@end
