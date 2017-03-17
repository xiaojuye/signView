//
//  LJsignView.h
//  LJsignView
//
//  Created by Gzedu on 2017/3/13.
//  Copyright © 2017年 Gzedu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LJsignViewDelegate <NSObject>

- (void)LJsignViewDelegateWithImage:(UIImage *)image;

@end

@interface LJsignView : UIView{
    UILabel *lblSignature;
    CAShapeLayer *shapeLayer;
}

- (UIImage *)getSignatureImage;
- (void)clearSignature;

@property (nonatomic,weak)id<LJsignViewDelegate>delegate;

@end
