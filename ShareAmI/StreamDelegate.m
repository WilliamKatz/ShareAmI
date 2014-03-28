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
    
    //xmppRoster
    _memoryRoster = [[XMPPRosterMemoryStorage alloc] init];
    _xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:_memoryRoster];
    [_xmppRoster activate:_xmppStream];
    _xmppRoster.autoFetchRoster = YES;
    
    
    [_xmppStream autoStartTLS];
    //[self connect];
    
}

-(BOOL) connect {
    NSError *error;
    NSString* domain = @"williamkatz.local";
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ShareAmI" accessGroup:nil];
    [_xmppStream setMyJID:[XMPPJID jidWithString: [NSString stringWithFormat:@"%@@%@", [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)], domain] ]];
    
    return [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
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
    NSString* password;
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ShareAmI" accessGroup:nil];
    NSData *pwd = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
    password =    [[NSString alloc] initWithData:pwd encoding:NSUTF8StringEncoding];
    
    if (!self.registerNewUser){
        [_xmppStream authenticateWithPassword:password  error:&error];
    }
    else{
        [_xmppStream registerWithPassword:password error:&error];
    }
}

- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    //registering
    [self loggedOn];
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    //pretty obvious
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    [self loggedOn];
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

-(void) loggedOn{
    loggedIn = YES;
    _xmppPresence = [XMPPPresence presence];
    [_xmppStream sendElement:_xmppPresence];
    [self.delegate popSignUpLogInView];
}
-(void) registerUser:(NSString*)username password:(NSString *)pword{
    
    self.registerNewUser = YES;
    [self saveCeredentials:username password:pword];
    [self connect];

    
}

-(void) saveCeredentials:(NSString *)username password:(NSString *)password{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ShareAmI" accessGroup:nil];
    [keychainItem setObject:username forKey:(__bridge id)(kSecAttrAccount)];
    [keychainItem setObject:password forKey:(__bridge id)(kSecValueData)];
}
@end
