//
//  UITableView+PageScan.h
//  JQPageScaner
//
//  Created by lvjiaqi on 16/7/3.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PrepareData)(UITableView *tableView , void (^callBack)(NSDictionary *msg));

typedef void(^replyBlock)(NSString *uid);
typedef void(^commentBlock)(NSString *uid);


@interface UITableView (PageScan)
-(BOOL)isloading;

-(void)statPageScanBlock:(PrepareData)block;
-(void)setReplyBlock:(replyBlock)block;
-(void)setCommentBlock:(commentBlock)block;
-(UIView *)controllView;

-(CGFloat)frameX;
-(CGFloat)frameY;
-(CGFloat)frameW;
-(CGFloat)frameH;
-(CGFloat)contentW;
-(CGFloat)contentH;
-(CGFloat)contentX;
-(CGFloat)contentY;
-(CGRect)frameRect;

@end
