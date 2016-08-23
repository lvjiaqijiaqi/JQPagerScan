//
//  UITableView+ProportyExtension.h
//  JQPageScaner
//
//  Created by lvjiaqi on 16/8/23.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ProportyExtension)

-(CGFloat)frameX;
-(CGFloat)frameY;
-(CGFloat)frameW;
-(CGFloat)frameH;

-(CGFloat)contentW;
-(CGFloat)contentH;
-(CGFloat)contentX;
-(CGFloat)contentY;

-(void)setOffsetToTop;

@end
