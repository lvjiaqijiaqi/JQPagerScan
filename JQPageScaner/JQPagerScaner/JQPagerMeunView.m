//
//  JQPagerMeunView.m
//  JQPageScaner
//
//  Created by lvjiaqi on 16/7/1.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//



#import "JQPagerMeunView.h"

@interface JQPagerMeunView()

@property(nonatomic,strong) UILabel *currenPageLabel;
@end

@implementation JQPagerMeunView


- (instancetype)initWithFrame:(CGRect)frame With:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        [self initMeunView];
    }
    return self;
}

-(void)initMeunView{
    
    CGFloat fragmentW = self.frame.size.width/8;
    CGFloat fragmentH = self.frame.size.height/4;
    
    UIButton *upBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    upBtn.frame = CGRectMake(0, fragmentH, fragmentW, fragmentH*2);
    [upBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    [upBtn addTarget:self.delegate action:@selector(beforePage) forControlEvents:UIControlEventTouchDown];
    
    UILabel *currenPageLabel = [[UILabel alloc] initWithFrame:CGRectMake(fragmentW, 0, fragmentW*2, fragmentH*4)];
    currenPageLabel.font = [UIFont systemFontOfSize:15];
    currenPageLabel.text = @"0/0";
    currenPageLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *downBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    downBtn.frame = CGRectMake(fragmentW*3, fragmentH, fragmentW, fragmentH*2);
    [downBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [downBtn addTarget:self.delegate action:@selector(nextPage) forControlEvents:UIControlEventTouchDown];
    
    
    UIButton *editBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    editBtn.frame = CGRectMake(fragmentW*4, fragmentH, fragmentW*2, fragmentH*2);
    editBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [editBtn setTitle:@" 回复" forState:UIControlStateNormal];
    [editBtn addTarget:self.delegate action:@selector(doReply) forControlEvents:UIControlEventTouchDown];
    
    UIButton *commentBtn =[UIButton buttonWithType:UIButtonTypeSystem];
    commentBtn.frame = CGRectMake(fragmentW*6, fragmentH, fragmentW*2, fragmentH*2);
    commentBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [commentBtn setTitle:@" 点评" forState:UIControlStateNormal];
    [commentBtn addTarget:self.delegate action:@selector(doEdit) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:upBtn];
    [self addSubview:downBtn];
    [self addSubview:editBtn];
    [self addSubview:commentBtn];
    [self addSubview:currenPageLabel];
    
    self.currenPageLabel = currenPageLabel;
    
    self.backgroundColor = [UIColor colorWithRed:240.0/256 green:248.0/256 blue:255.0/256 alpha:1];
    
}

-(void)setCurrent:(NSInteger)page of:(NSInteger)pages{

     self.currenPageLabel.text = [NSString stringWithFormat:@"%ld / %ld",(long)page , (long)pages];
    
}

@end
