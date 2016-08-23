//
//  UITableView+ProportyExtension.m
//  JQPageScaner
//
//  Created by lvjiaqi on 16/8/23.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import "UIScrollView+ProportyExtension.h"

@implementation UIScrollView (ProportyExtension)


#pragma -mark frame

-(CGFloat)frameX{
    return self.frame.origin.x;
}
-(CGFloat)frameY{
    return self.frame.origin.y;
}
-(CGFloat)frameW{
    return self.frame.size.width;
}
-(CGFloat)frameH{
    return self.frame.size.height;
}


#pragma -mark content

-(CGFloat)contentW{
    return self.contentSize.width;
}
-(CGFloat)contentH{
    return self.contentSize.height;
}
-(CGFloat)contentX{
    return self.contentOffset.x;
}
-(CGFloat)contentY{
    return self.contentOffset.y;
}

-(void)setOffsetToTop{
    [self setContentOffset:CGPointMake(0, -self.contentInset.top) animated:NO];
}

@end
