//
//  TitleView.m
//  JQPageScaner
//
//  Created by lvjiaqi on 16/7/7.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import "TitleView.h"

@interface TitleView()

@property(nonatomic,strong) UILabel* titleLable;
@property(nonatomic,strong) UILabel* scanLable;
@property(nonatomic,strong) UILabel* replyView;
@property(nonatomic,strong) UILabel* zoneView;

@end

@implementation TitleView

-(UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2);
        _titleLable.text = @"标题";
        _titleLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLable];
    }
    return _titleLable;
}
-(UILabel *)scanLable{
    if (!_scanLable) {
        _scanLable = [[UILabel alloc] init];
        _scanLable.frame = CGRectMake(0, self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height/2);
        _scanLable.text = @"浏览数";
        _scanLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_scanLable];
        
    }
    return _scanLable;
}
-(UILabel *)replyView{
    if (!_replyView) {
        _replyView = [[UILabel alloc] init];
        _replyView.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height/2, self.frame.size.width/2, self.frame.size.height/2);
        _replyView.text = @"回复数";
        _replyView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_replyView];
    }
    return _titleLable;
}
-(UILabel *)zoneView{
    if (!_zoneView) {
        _zoneView = [[UILabel alloc] init];
        _zoneView.text = @"板块数";
        _zoneView.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_zoneView];
    }
    return _titleLable;
}


- (instancetype)initWithFrame:(CGRect)frame andMsg:(NSDictionary *)msg
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scanLable.hidden = NO;
        self.replyView.hidden = NO;
        self.zoneView.hidden = NO;
        self.titleLable.hidden = NO;
        [self updateMsg:msg];
    }
    return self;
}

-(void)updateMsg:(NSDictionary *)msg{
    _titleLable.text = [msg objectForKey:@"title"];
    _scanLable.text = [msg objectForKey:@"scan"];
    _replyView.text = [msg objectForKey:@"reply"];
    _uId = [msg objectForKey:@"Uid"];
   // _zoneView.text = [msg objectForKey:@"zone"];
}

@end
