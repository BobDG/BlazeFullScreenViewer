//
//  FullScreenViewerViewController.h
//
//  Created by Bob de Graaf on 11-05-17.
//  Copyright © 2017 GraafICT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Blaze/BlazeMediaData.h>

@interface FullScreenViewerViewController : UIViewController
{
    
}

//Handy creation methods
+(FullScreenViewerViewController *)fullScreenViewerWithMediaData:(NSArray <BlazeMediaData *> *)mediaArray;
+(FullScreenViewerViewController *)fullScreenViewerWithMediaData:(NSArray <BlazeMediaData *> *)mediaArray index:(int)index;
+(void)showFullScreenViewerFromViewController:(UIViewController *)viewController mediaData:(NSArray <BlazeMediaData *> *)mediaArray;
+(void)showFullScreenViewerFromViewController:(UIViewController *)viewController mediaData:(NSArray <BlazeMediaData *> *)mediaArray index:(int)index;

//Public properties
@property(nonatomic) int selectedIndex;
@property(nonatomic,strong) UIColor *pageControlTintColor;
@property(nonatomic,strong) UIColor *pageControlCurrentPageColor;
@property(nonatomic,strong) NSArray <BlazeMediaData *> *mediaArray;

@end
