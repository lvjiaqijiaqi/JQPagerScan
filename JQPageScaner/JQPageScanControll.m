//
//  JQPageScanControll.m
//  JQPageScaner
//
//  Created by lvjiaqi on 16/7/3.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//
#define contentInsetTop 1
#define meunViewHeight 50
#define titleViewHeight 100

#define topLimit 80
#define buttomLimit 80

#import "JQPageScanControll.h"
#import "TitleView.h"
#import "UIScrollView+ProportyExtension.h"

@interface JQPageScanControll()<JQPagerMeunDelegate,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,weak) UITableView *PageTableView;

@property(nonatomic) NSInteger currentPage;
@property(nonatomic) NSInteger numberOfPage;
@property(nonatomic) NSInteger numberOfPages;

@property(nonatomic,strong) TitleView* titleView;
@property(nonatomic,strong) JQPagerMeunView *pagerMeunView;

@property(nonatomic,strong) UILabel *headLabelOfTable;
@property(nonatomic,strong) UILabel *tailLabelOfTable;

@property(nonatomic,strong) UIImageView *shadowView;

@end

@implementation JQPageScanControll



#pragma mark - LazyLoadViews

-(UILabel *)headLabelOfTable{
    if (!_headLabelOfTable) {
        UILabel *headLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self.PageTableView frameW], 30)];
        [headLable setCenter:CGPointMake([self.PageTableView frameW]/2,  -30-_PageTableView.contentInset.top )];
        headLable.textAlignment = NSTextAlignmentCenter;
        headLable.hidden = NO;
        headLable.text = @"首页";
        [self.PageTableView addSubview:headLable];
        self.headLabelOfTable = headLable;
    }
    return _headLabelOfTable;
}

-(UILabel *)tailLabelOfTable{
    if (!_tailLabelOfTable) {
        UILabel *tailLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self.PageTableView frameW], 30)];
        tailLable.textAlignment = NSTextAlignmentCenter;
        tailLable.hidden = YES;
        tailLable.text = @"下拉至第2页";
        [self.PageTableView addSubview:tailLable];
        self.tailLabelOfTable = tailLable;
    }
    return  _tailLabelOfTable;
}

-(TitleView *)titleView{
    if (_titleView == nil) {
        TitleView *titleView = [[TitleView alloc] initWithFrame:CGRectMake(0, -titleViewHeight, [self.PageTableView frameW], titleViewHeight) andMsg:nil];
        [_PageTableView addSubview:titleView];
        UIEdgeInsets ed= _PageTableView.contentInset;
        ed.top = ed.top+titleViewHeight;
        [_PageTableView setContentInset:ed];
        _titleView.hidden = NO;
        _titleView = titleView;
    }
    return _titleView;
}

-(JQPagerMeunView *)pagerMeunView{
    if (_pagerMeunView == nil) {
        JQPagerMeunView *pageMenu = [[JQPagerMeunView alloc] initWithFrame:CGRectMake(0, -meunViewHeight-titleViewHeight+[_PageTableView frameH],[_PageTableView frameW], meunViewHeight) With:self];
        _pagerMeunView = pageMenu;
        
        UIEdgeInsets ed= _PageTableView.contentInset;
        ed.bottom = ed.bottom+meunViewHeight;
        [_PageTableView setContentInset:ed];
        
        [_PageTableView addSubview:_pagerMeunView];
    }
    return _pagerMeunView;
}


#pragma mark - ObserveControll

-(void)startListening:(UITableView *)tabelView{
    
    [tabelView addObserver:self forKeyPath:@"panGestureRecognizer.state" options:NSKeyValueObservingOptionNew context:nil];
    [tabelView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [tabelView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    tabelView.delegate = self;
    self.PageTableView = tabelView;
    _PageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.titleView.hidden = NO;
    self.headLabelOfTable.hidden = NO;
    self.tailLabelOfTable.hidden = YES;
    self.pagerMeunView.hidden = NO;
    
    _numberOfPage = 10;
    _numberOfPages = 0;
    _currentPage = 0;
    _isloading = NO;
    
    [self updateDataFromSource];
}

-(void)removeListening:(UITableView *)tabelView{
    [tabelView removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
    [tabelView removeObserver:self forKeyPath:@"contentSize"];
    [tabelView removeObserver:self forKeyPath:@"contentOffset"];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
   if ([keyPath isEqual:@"contentSize"]){
        [self adjustTheTailY:[change[@"new"] CGSizeValue].height];
       
    }else if ([keyPath isEqual:@"contentOffset"]){
        
        if ([change[@"new"] CGPointValue].y > (-meunViewHeight-titleViewHeight) ) {
            
            _pagerMeunView.frame = CGRectMake(0, [change[@"new"] CGPointValue].y+[_PageTableView frameH]-meunViewHeight,[_PageTableView frameW], meunViewHeight);
        }else{
            
            _pagerMeunView.frame = CGRectMake(0, -meunViewHeight-titleViewHeight+[_PageTableView frameH],[_PageTableView frameW], meunViewHeight);
        }
        
    }else if([keyPath isEqual:@"panGestureRecognizer.state"]){
        NSInteger pp = [self isTriggleSwitchPage:_PageTableView];
        if ( pp != 0 ) {
             UIImageView *imageView = [self createMaskView];
             void (^completeBlk)(BOOL) = ^(BOOL finish){
             [imageView removeFromSuperview];
             _PageTableView.scrollEnabled = YES;
             };
             [completeBlk copy];
             
             if (pp == 1) {
             [_PageTableView.superview insertSubview:imageView aboveSubview:_PageTableView];
             [self pageAnimation:imageView ByStainView:_PageTableView InType:NO withBlock:completeBlk];
             }else{
             [_PageTableView.superview insertSubview:imageView belowSubview:_PageTableView];
             [self pageAnimation:_PageTableView ByStainView:imageView InType:YES withBlock:completeBlk];
             }
            
              self.isloading = YES;
              self.currentPage = _currentPage + pp;
             }
    }
}


#pragma mark - pageSwitch 


-(void)removeAllCells:(UITableView *)tableView{
    for (id cell in tableView.subviews[0].subviews) {
        if ( [cell isKindOfClass:[UITableViewCell class]] ) {
             [cell removeFromSuperview];
        }
    }
}
-(void)pageAnimation:(UIView *)slideView ByStainView:(UIView *)stainView InType:(BOOL)type withBlock:(void (^)(BOOL finished))completeBlk{ //YES划入 NO划出
    
    slideView.transform = type ? CGAffineTransformMakeTranslation(0, -slideView.frame.size.height) : CGAffineTransformMakeTranslation(0,0) ;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        slideView.transform = type ? CGAffineTransformMakeTranslation(0, 0) : CGAffineTransformMakeTranslation(0,-slideView.frame.size.height) ;
    } completion:completeBlk];
    
}

-(void)setCurrentPage:(NSInteger)currentPage{
    
    _currentPage = currentPage;
    _PageTableView.tag = currentPage;
    
    if ([_PageTableView.dataSource tableView:_PageTableView numberOfRowsInSection:0] == 0) {
          [_PageTableView reloadData];
    }else{
          [_PageTableView setContentOffset:CGPointZero animated:NO];
    }
    
    [self updateDataFromSource];
    
}

-(void)updateDataFromSource{
    
    void (^callBack)(Post *) = ^(Post *post){
        if (post != nil) {
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:post.title,@"title",post.Uid,@"Uid",post.reply,@"reply",post.scan,@"scan",nil];
            [self.titleView updateMsg:dic];
            
            _numberOfPages = [post.numberOfPages intValue];
        }
         _isloading = NO;
    };
    
    self.prepareData([callBack copy]);
    [self refreashStatus];
    
}

-(void)refreashStatus{
    [self.pagerMeunView setCurrent:_currentPage+1 of:_numberOfPages];
    self.headLabelOfTable.text = _currentPage != 0 ? [[NSString alloc] initWithFormat:@"上拉至第%ld页",(long)_currentPage] : @"首页";
    self.tailLabelOfTable.text = _currentPage+1 != _numberOfPages? [[NSString alloc] initWithFormat:@"下拉至第%ld页",(long)_currentPage+2] : @"没有啦";
}

-(void)adjustTheTailY:(CGFloat)h{
    
    if (h == 0) return;
    self.tailLabelOfTable.hidden = NO;
    [self.tailLabelOfTable setCenter:CGPointMake(self.tailLabelOfTable.center.x, h+50)];
    
}


#pragma mark - MaskView

-(UIImageView *)createMaskView{
    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake([_PageTableView frameX], [_PageTableView frameY], [_PageTableView frameW],[_PageTableView frameH])];
    maskView.image = [self convertViewToImage:_PageTableView.superview];
    return maskView;
}
-(UIImage*)convertViewToImage:(UIView *)v{
    CGSize s = CGSizeMake(v.frame.size.width, v.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [v.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, CGRectMake([_PageTableView frameX]*[UIScreen mainScreen].scale, [_PageTableView frameY]*[UIScreen mainScreen].scale, [_PageTableView frameW]*[UIScreen mainScreen].scale, [_PageTableView frameH]*[UIScreen mainScreen].scale));
    UIImage *image = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return image;
}


#pragma mark - UIscrollViewDelegate

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 500;
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if ( self.isloading ) {
          targetContentOffset->y = scrollView.contentOffset.y;
    }

}
-(NSInteger)isTriggleSwitchPage:(UIScrollView *)scrollView{
    
    if ( _isloading) {
        return 0 ;
    }
    
    if ( [scrollView contentY] < - (topLimit + scrollView.contentInset.top) ) {
        return _currentPage <= 0 ? 0 : -1;
        
    }else if( [scrollView contentY] > [scrollView contentH] - [scrollView frameH] + buttomLimit
    ){
        return _currentPage+1 >= _numberOfPages? 0 : 1;
        
    }
    return 0;
}



#pragma mark - PageViewDelegate

-(void)doEdit{
    self.rblock(_titleView.uId);
}
-(void)doReply{
    self.rblock(_titleView.uId);
}
-(void)nextPage{
    self.currentPage = _currentPage+1;
}
-(void)jumpTo:(NSInteger)page{
   self.currentPage = page;
}
-(void)beforePage{
   self.currentPage = _currentPage-1;
}



@end
