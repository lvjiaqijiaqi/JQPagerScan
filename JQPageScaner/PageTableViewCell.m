//
//  PageTableViewCell.m
//  Pager
//
//  Created by lvjiaqi on 16/6/26.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import "PageTableViewCell.h"


@implementation PageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (CGRect)contentSizeRectForTextView:(UITextView *)textView
{
    [textView.layoutManager ensureLayoutForTextContainer:textView.textContainer];
    CGRect textBounds = [textView.layoutManager usedRectForTextContainer:textView.textContainer];
    
    CGFloat width =  (CGFloat)ceil(textBounds.size.width + textView.textContainerInset.left + textView.textContainerInset.right);
    CGFloat height = (CGFloat)ceil(textBounds.size.height + textView.textContainerInset.top + textView.textContainerInset.bottom);
    
    return CGRectMake(0, 0, width, height);
}



-(CGFloat)parseBody:(NSString *)body{
   
    NSMutableAttributedString *bodyStr = [[NSMutableAttributedString alloc] initWithString:body];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineSpacing:5];
    [paragraphStyle setParagraphSpacingBefore:5];
    [bodyStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, bodyStr.length)];
    
    [bodyStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, bodyStr.length)];
    
    [self.bodyLabel setFrame:CGRectMake(self.bodyLabel.frame.origin.x, self.bodyLabel.frame.origin.y, 300, 0)];
    self.bodyLabel.attributedText = bodyStr;
    self.bodyLabel.editable = NO;
    
    CGFloat h = [self contentSizeRectForTextView:self.bodyLabel].size.height;
    
    return h;
}




-(void)parseData:(Floor *)f{
    
    self.nameLabel.text = f.username;

    self.statusLabel.text = f.status;
    
    self.floorLabel.text = f.floorNum;
    
    f.bodyH = [self parseBody:f.body];

    [self.bodyLabel setFrame:CGRectMake(self.bodyLabel.frame.origin.x, self.bodyLabel.frame.origin.y, self.bodyLabel.frame.size.width, f.bodyH)];
    
}

-(void)updateConstraints{

    self.bodyConstrain.constant = self.bodyLabel.frame.size.height;
    
   [super updateConstraints];
 
}

@end
