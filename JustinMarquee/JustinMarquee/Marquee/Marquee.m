//
//  Marquee.m
//  JustinMarquee
//
//  Created by JustinChou on 16/8/19.
//  Copyright © 2016年 JustinChou. All rights reserved.
//

#import "Marquee.h"
#import "MarqueeWaterFlowLayout.h"
#import "MarqueeCollectionViewCell.h"

#define kMarqueeCollectionViewCell @"kMarqueeCollectionViewCell"

@interface Marquee ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *itemWidthArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat currentX;
@property (nonatomic, strong) NSTimer *collectionViewTimer;

@end

@implementation Marquee

- (NSMutableArray *)itemWidthArray {
    if (_itemWidthArray == nil) {
        _itemWidthArray = [[NSMutableArray alloc] init];
    }
    return _itemWidthArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.currentX = 0.0f;
        
        MarqueeWaterFlowLayout *layout = [[MarqueeWaterFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        self.collectionView = collectionView;
        collectionView.backgroundColor = [UIColor yellowColor];
        
        [collectionView registerClass:[MarqueeCollectionViewCell class] forCellWithReuseIdentifier:kMarqueeCollectionViewCell];
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [self addSubview:collectionView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.resourceArray.count > 1) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.resourceArray.count inSection:0];
                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
            }
        });
        
        [NSTimer scheduledTimerWithTimeInterval:1/60 target:self selector:@selector(pxy_autoScrollCollectionView) userInfo:nil  repeats:true];
        
    }
    return self;
}

#pragma mark - getter & setter
- (void)setResourceArray:(NSArray *)resourceArray {
    _resourceArray = resourceArray;
    
    [_itemWidthArray removeAllObjects];
    for (NSString *str in resourceArray) {
        UILabel *label = [[UILabel alloc] init];
        [label setText:str];
        [label sizeToFit];
        
        [self.itemWidthArray addObject:@(label.frame.size.width)];
    }
    
    NSLog(@"%@", self.itemWidthArray);
    
}
#pragma mark - delegate & datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.resourceArray.count * (self.resourceArray.count == 2 ? 2 : 20);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MarqueeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMarqueeCollectionViewCell forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0];
    cell.textLabelStr = self.resourceArray[indexPath.item % self.resourceArray.count];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize itemSize = CGSizeMake([self.itemWidthArray[indexPath.item % self.resourceArray.count] floatValue], 20);
    return itemSize;
}

#pragma mark - other function
- (void)pxy_autoScrollCollectionView {
    self.collectionView.contentOffset = CGPointMake(self.currentX, 0);
    self.currentX = self.currentX + 0.0025;
}

@end
