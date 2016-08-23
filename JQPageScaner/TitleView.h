//
//  TitleView.h
//  JQPageScaner
//
//  Created by lvjiaqi on 16/7/7.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleView : UIView

@property(nonatomic,strong) NSString* uId;

-(instancetype)initWithFrame:(CGRect)frame andMsg:(NSDictionary *)msg;
-(void)updateMsg:(NSDictionary *)msg;

@end
