//
//  Comment.h
//  rs
//
//  Created by lvjiaqi on 16/6/29.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property(strong,nonatomic) NSString *time;
@property(strong,nonatomic) NSString *body;
@property(strong,nonatomic) NSString *uid;
@property(strong,nonatomic) NSString *username;
@property(strong,nonatomic) NSString *cid;

@end
