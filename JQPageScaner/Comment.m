//
//  Comment.m
//  rs
//
//  Created by lvjiaqi on 16/6/29.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import "Comment.h"

@implementation Comment


- (instancetype)init
{
    self = [super init];
    if (self) {
        _time = @"";
        _body = @"";
        _uid = @"";
        _username = @"";
        _cid = @"";
    }
    return self;
}
@end
