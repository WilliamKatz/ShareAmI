//
//  BKAnnotation.m
//  ShareAmI
//
//  Created by William Katz on 5/29/14.
//  Copyright (c) 2014 William Katz. All rights reserved.
//

#import "BKAnnotation.h"

@interface BKAnnotation ()

@property (readwrite) NSString *title;
@property (readwrite) BOOL selected;

@end

@implementation BKAnnotation

-(void) assignTitle:(NSString *)newTitle {
    if ( ![newTitle isEqualToString:[self title]]){
        self.title = newTitle;
    }
}

-(void) assignSelected:(BOOL)boolVal{
    self.selected = boolVal;
}

@end


