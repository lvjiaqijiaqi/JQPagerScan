//
//  PageTableViewCell.h
//  Pager
//
//  Created by lvjiaqi on 16/6/26.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Floor.h"

@interface PageTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *headerImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *floorLabel;

@property (strong, nonatomic) IBOutlet UITextView *bodyLabel;
@property (strong, nonatomic) IBOutlet UITextView *commentView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bodyConstrain;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentConstrain;

-(void)parseData:(Floor *)f;
@end
