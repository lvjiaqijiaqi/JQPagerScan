//
//  JQPagerMeunView.h
//  JQPageScaner
//
//  Created by lvjiaqi on 16/7/1.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JQPagerMeunDelegate <NSObject>

@optional
-(void)nextPage;
-(void)beforePage;
-(void)jumpTo:(NSInteger)page;
-(void)doEdit;
-(void)doReply;
@end

@interface JQPagerMeunView : UIView

@property(nonatomic,weak) id<JQPagerMeunDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame With:(id)delegate;
-(void)setCurrent:(NSInteger)page of:(NSInteger)pages;

@end
