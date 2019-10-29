//
//  HXDatePhotoViewController.h
//  微博照片选择
//
//  Created by 洪欣 on 2017/10/14.
//  Copyright © 2017年 洪欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXPhotoManager.h"

@class HXDatePhotoViewController;
@protocol HXDatePhotoViewControllerDelegate <NSObject>
@optional
- (void)datePhotoViewControllerDidCancel:(HXDatePhotoViewController *)datePhotoViewController;
- (void)datePhotoViewController:(HXDatePhotoViewController *)datePhotoViewController didDoneAllList:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photoList videos:(NSArray<HXPhotoModel *> *)videoList original:(BOOL)original;
- (void)datePhotoViewControllerDidChangeSelect:(HXPhotoModel *)model selected:(BOOL)selected;
@end

@interface HXDatePhotoViewController : UIViewController
@property (weak, nonatomic) id<HXDatePhotoViewControllerDelegate> delegate;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXAlbumModel *albumModel;
@end

@class HXDatePhotoViewCell;
@protocol HXDatePhotoViewCellDelegate <NSObject>
@optional
- (void)datePhotoViewCell:(HXDatePhotoViewCell *)cell didSelectBtn:(UIButton *)selectBtn;
@end

@interface HXDatePhotoViewCell : UICollectionViewCell
@property (weak, nonatomic) id<HXDatePhotoViewCellDelegate> delegate;
@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic) HXPhotoModel *model;
@end

@interface HXDatePhotoViewSectionHeaderView : UICollectionReusableView
@property (strong, nonatomic) HXPhotoDateModel *model;
@end

@protocol HXDatePhotoBottomViewDelegate <NSObject>
@optional
- (void)datePhotoBottomViewDidPreviewBtn;
- (void)datePhotoBottomViewDidDoneBtn;
@end

@interface HXDatePhotoBottomView : UIView
@property (weak, nonatomic) id<HXDatePhotoBottomViewDelegate> delegate;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (assign, nonatomic) BOOL previewBtnEnabled;
@property (assign, nonatomic) BOOL doneBtnEnabled;
@property (assign, nonatomic) NSInteger selectCount;
@end
