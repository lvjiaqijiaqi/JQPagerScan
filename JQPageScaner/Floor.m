//
//  Floor.m
//  rs
//
//  Created by lvjiaqi on 16/6/22.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import "Floor.h"

@implementation Floor


- (instancetype)init
{
    self = [super init];
    if (self) {
        _time = @"";
        _username = @"";
        _floorNum = @"";
        _status = @"";
        _body = @"";
        _bodyH = 0;
        _commentH = 0;
        _comments = [NSArray array];
        _rates = [NSMutableArray array];
        
    }
    return self;
}
@end
