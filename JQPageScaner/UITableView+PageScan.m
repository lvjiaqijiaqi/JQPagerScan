//
//  UITableView+PageScan.m
//  JQPageScaner
//
//  Created by lvjiaqi on 16/7/3.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import "UITableView+PageScan.h"
#import <objc/runtime.h>
#import "JQPageScanControll.h"


@implementation UITableView (PageScan)



void df_swizzling_method(Class class,const char *orignSelName,  const char *newSelName)
{
    SEL orignSelector = sel_registerName(orignSelName);
    SEL newSelector = sel_registerName(newSelName);
    Method originM = class_getInstanceMethod(class, orignSelector);
    Method newM = class_getInstanceMethod(class, newSelector);
    if (class_addMethod(class, orignSelector, method_getImplementation(newM), method_getTypeEncoding(newM)))
    {
        class_replaceMethod(class, newSelector, method_getImplementation(originM), method_getTypeEncoding(originM));
    }
    else
    {
       method_exchangeImplementations(originM, newM);
    }
}


+ (void)load
{
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        //交换reloadData方法，方便结束下拉刷新动画
        df_swizzling_method([self class],"Q_layoutSubviews", "layoutSubviews");
        
        //交换dealloc方法，方便取消kvo监听
       // df_swizzling_method(self.class, "dealloc", "df_dealloc");
    });
}


-(void)Q_layoutSubviews{
 
    [self Q_layoutSubviews];
    
}

static char  pageScanKey;

- (JQPageScanControll *)pageScan
{
    JQPageScanControll *pageScan = objc_getAssociatedObject(self, &pageScanKey);
    if (!pageScan)
    {
        pageScan = [[JQPageScanControll alloc] init];
        [self setPageScan:pageScan];
    }
    return pageScan;
}

-(void)setPageScan:(JQPageScanControll *)pageScan{
     objc_setAssociatedObject(self, &pageScanKey, pageScan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}




-(UIView *)controllView{
    return [self pageScan].pagerMeunView;
}


-(void)statPageScanBlock:(PrepareData)block{
    
    [[self pageScan] startListening:self];
    [self pageScan].prepareData = block;
    [self pageScan].isloading = YES;
    [[self pageScan] updateDataFromSource:YES];
    
}

-(void)setReplyBlock:(replyBlock)block{
    [self pageScan].cblock = block;
}
-(void)setCommentBlock:(commentBlock)block{
    [self pageScan].rblock = block;
}



-(BOOL)isloading{
    return [self pageScan].isloading;
}





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
-(CGRect)frameRect{
    return self.frame;
}



@end
