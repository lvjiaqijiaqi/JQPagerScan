//
//  JQPageScanControll.h
//  JQPageScaner
//
//  Created by lvjiaqi on 16/7/3.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableView+PageScan.h"
#import "JQPagerMeunView.h"

@interface JQPageScanControll : NSObject

@property (nonatomic, copy) PrepareData prepareData;
@property (nonatomic, copy) replyBlock rblock;
@property (nonatomic, copy) commentBlock cblock;
@property(nonatomic) BOOL isloading;

-(void)startListening:(UITableView *)tabelView;
-(JQPagerMeunView *)pagerMeunView;
-(void)updateDataFromSource:(BOOL)sourcing;
@end
