//
//  StreamDelegate.m
//  ShareAmI
//
//  Created by William Katz on 3/10/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import "StreamDelegate.h"
#import "AppDelegate.h"
#import "AddressBook/AddressBook.h"

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

#pragma  mark XMPPStream Delegate and Helper Methods


-(void) setupStream {
    //set up the stream
    instance = self;
    _xmppStream = [[XMPPStream alloc] init];
    [_xmppStream setHostName:@"William-Katzs-MacBook-Pro-2.local"];
    [_xmppStream setHostPort:5222];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    _serverName = @"williamkatz.local";
    //xmppRoster
    // [[(AppDelegate *)[[UIApplication sharedApplication] delegate] rosterDelegate] setup];
    
    
    [_xmppStream autoStartTLS];
    //[self connect];
    
    _addableBuddies = [[NSMutableArray alloc] init];
    
}


-(BOOL) connect {
    NSError *error;
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"ShareAmI" accessGroup:nil];
    [_xmppStream setMyJID:[XMPPJID jidWithString: [NSString stringWithFormat:@"%@@%@", [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)], _serverName] ]];
    
    return [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error];
}

-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    NSLog(@"%@",[error description]);
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

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    //pretty obvious
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    [self loggedOn];
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    //did not, show error?
    NSLog(@"failure cause %@", error);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    
    if ( [[iq fromStr] isEqualToString:@"search.williamkatz.local"]){
        if ([[[[[iq childElement] childAtIndex:0] childAtIndex:2] name] isEqualToString:@"item"]){
            NSLog(@"foudnd!!!1, %@", [[[[[[iq childElement] childAtIndex:0] childAtIndex:2] childAtIndex:2] childAtIndex:0] stringValue]);
            [[[[[[iq childElement] childAtIndex:0] childAtIndex:2] childAtIndex:2] childAtIndex:0] stringValue];
        }
    }
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence{
    
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(DDXMLElement *)error{
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

#pragma mark - Other methods


-(void) loggedOn{
    //logged on, set up buddy list
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


-(void) searchFor: (NSString*) user {
    NSString *userBare1  = [[_xmppStream myJID] bare];
    
    DDXMLElement *query = [DDXMLElement elementWithName:@"query"];
    [query addAttributeWithName:@"xmlns" stringValue:@"jabber:iq:search"];
    
    
    DDXMLElement *x = [DDXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    [x addAttributeWithName:@"type" stringValue:@"submit"];
    
    DDXMLElement *formType = [DDXMLElement elementWithName:@"field"];
    [formType addAttributeWithName:@"type" stringValue:@"hidden"];
    [formType addAttributeWithName:@"var" stringValue:@"FORM_TYPE"];
    [formType addChild:[DDXMLElement elementWithName:@"value" stringValue:@"jabber:iq:search" ]];
    
    DDXMLElement *userName = [DDXMLElement elementWithName:@"field"];
    [userName addAttributeWithName:@"var" stringValue:@"Username"];
    [userName addChild:[DDXMLElement elementWithName:@"value" stringValue:@"1" ]];
    
    DDXMLElement *name = [DDXMLElement elementWithName:@"field"];
    [name addAttributeWithName:@"var" stringValue:@"Name"];
    [name addChild:[DDXMLElement elementWithName:@"value" stringValue:@"1"]];
    
    DDXMLElement *email = [DDXMLElement elementWithName:@"field"];
    [email addAttributeWithName:@"var" stringValue:@"Email"];
    [email addChild:[DDXMLElement elementWithName:@"value" stringValue:@"1"]];
    
    DDXMLElement *search = [DDXMLElement elementWithName:@"field"];
    [search addAttributeWithName:@"var" stringValue:@"search"];
    [search addChild:[DDXMLElement elementWithName:@"value" stringValue:@"kate-bell@mac.com"]];
    
    [x addChild:formType];
    [x addChild:userName];
    //[x addChild:name];
    [x addChild:email];
    [x addChild:search];
    [query addChild:x];
    
    
    DDXMLElement *iq = [DDXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    [iq addAttributeWithName:@"id" stringValue:@"searchByUserName"];
    [iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"search.williamkatz.local"]];
    [iq addAttributeWithName:@"from" stringValue:userBare1];
    [iq addChild:query];
    [_xmppStream sendElement:iq];
}

-(void) findAddableBuddies: (NSMutableArray*) contacts {
    for (int i =0 ; i < 1 ; i++){
        //email
        ABMutableMultiValueRef multi = ABRecordCopyValue((__bridge ABRecordRef)([contacts objectAtIndex:i]), kABPersonPhoneProperty);
        //NSMutableArray* emailArray = [[NSMutableArray alloc] init];
        multi = ABRecordCopyValue((__bridge ABRecordRef)([contacts objectAtIndex:i]), kABPersonEmailProperty);
        if (ABMultiValueGetCount(multi) > 0) {
            // collect all emails in array
            for (CFIndex i = 0; i < 1; i++) {
                CFStringRef emailRef = ABMultiValueCopyValueAtIndex(multi, i);
//                [self searchFor: (__bridge NSString*) emailRef];
//                [self searchFor:@"kate"];
                [self searchFor: (__bridge NSString*) emailRef];
            }
            
        }
        
        //[self searchFor:(__bridge NSString*) ABRecordCopyValue((__bridge ABRecordRef)([contacts objectAtIndex:i]), kABPersonEmailProperty)];
    }
    
}

-(void) requestBuddy:(NSMutableString *)user{
    NSMutableString *toUser = [[NSMutableString alloc] initWithString:user];
    NSMutableString *fromMe = [NSMutableString stringWithString:[[_xmppStream myJID] user]];
    
    [fromMe appendString:@"@"];
    [toUser appendString:@"@"];
    
    [fromMe appendString:_serverName];
    [toUser appendString:_serverName];
    
    
    DDXMLElement *presence = [DDXMLElement elementWithName:@"presence"];
    [presence addAttributeWithName:@"type" stringValue:@"subscribe"];
    [presence addAttributeWithName:@"to" stringValue:toUser];
    DDXMLElement *from = [DDXMLElement elementWithName:@"from"];
    [from setStringValue: fromMe];
    [presence addChild:from];
    
    [_xmppStream sendElement:presence];
    NSLog(@"%@", [presence description]);
    
}


@end
