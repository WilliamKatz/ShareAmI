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
@synthesize  loggedIn;

static StreamDelegate *instance = nil;
+(StreamDelegate*)getInstance{
    @synchronized(self)
    {
        if(instance==nil)
        {
            
            instance= [StreamDelegate new];
        }
    }
    return instance;
}

-(void) setupStream {
    //set up the stream
    instance = self;
    _xmppStream = [[XMPPStream alloc] init];
    [_xmppStream setHostName:@"William-Katzs-MacBook-Pro-2.local"];
    [_xmppStream setHostPort:5222];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
//    XMPPAutoPing *autoping = [[XMPPAutoPing alloc] init];
//    [autoping activate:_xmppStream];
    
    //xmppRoster
    _memoryRoster = [[XMPPRosterMemoryStorage alloc] init];
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_memoryRoster];
    [_xmppRoster activate:_xmppStream];
    _xmppRoster.autoFetchRoster = YES;
    
    NSError* error;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
   
    
}

-(BOOL) connect {
    NSError *error;
    NSString* domain = @"williamkatz.local";
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ShareAmI" accessGroup:nil];
    [_xmppStream setMyJID:[XMPPJID jidWithString: [NSString stringWithFormat:@"%@@%@", [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)], domain] ]];
    if ([_xmppStream connectWithTimeout: XMPPStreamTimeoutNone error: &error]){
        return YES;
    }
    else return NO;
}

-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"%@",error);
}

-(void)xmppStreamConnectDidTimeout:(XMPPStream *)sender{
    NSLog(@"connection time out");
}
- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
    [settings setObject:@YES forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
}

- (void)xmppStreamWillConnect:(XMPPStream *)sender{
    //maybe use if I want to indicate this will run in background
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    //safe to begin communication with server
    NSError *error;
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ShareAmI" accessGroup:nil];
    NSData *pwd = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    NSString* password =    [[NSString alloc] initWithData:pwd encoding:NSUTF8StringEncoding];
    //[_xmppStream authenticateWithPassword:password  error:&error];
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
    loggedIn = YES;
    _xmppPresence = [XMPPPresence presence];
    [_xmppStream sendElement:_xmppPresence];    
    
    [self.delegate popSignUpLogInView];
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
    //NSLog (@"%@", [presence name]);
    
}

-(void) registerUser{
    //same as connect?
    [self connect];
    NSError *error;
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ShareAmI" accessGroup:nil];
    NSString* domain = @"williamkatz.local";
    [_xmppStream setMyJID:[XMPPJID jidWithString: [NSString stringWithFormat:@"%@@%@", [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)], domain] ]];
    NSData *pwd = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    NSString* password =    [[NSString alloc] initWithData:pwd encoding:NSUTF8StringEncoding];
    [_xmppStream registerWithPassword:password error:&error];
    
}

-(void) saveCeredentials:(NSString *)username password:(NSString *)password{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ShareAmI" accessGroup:nil];
    [keychainItem setObject:username forKey:(__bridge id)(kSecAttrAccount)];
    [keychainItem setObject:password forKey:(__bridge id)(kSecValueData)];
}
@end
