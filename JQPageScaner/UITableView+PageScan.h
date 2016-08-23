//
//  UITableView+PageScan.h
//  JQPageScaner
//
//  Created by lvjiaqi on 16/7/3.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

typedef void(^PrepareData)(void (^callBack)(Post *post));

typedef void(^replyBlock)(NSString *uid);
typedef void(^commentBlock)(NSString *uid);


@interface UITableView (PageScan)

-(void)statPageScanBlock:(PrepareData)block;
-(void)setReplyBlock:(replyBlock)block;
-(void)setCommentBlock:(commentBlock)block;
-(UIView *)controllView;



@end
