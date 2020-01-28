//
//  FullScreenViewerViewController.m
//
//  Created by Bob de Graaf on 11-05-17.
//  Copyright © 2017 GraafICT. All rights reserved.
//

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

#import "FullScreenViewerViewController.h"

@interface FullScreenViewerViewController () <UIScrollViewDelegate>
{
    
}

@property(nonatomic) bool showedIndex;

@property(nonatomic,strong) NSMutableArray *viewsArray;
@property(nonatomic,strong) NSMutableArray *videoPlayersArray;

@property(nonatomic,weak) IBOutlet UIButton *closeButton;
@property(nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property(nonatomic,weak) IBOutlet UIPageControl *pageControl;

@end

@implementation FullScreenViewerViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //Delegate
    self.scrollView.delegate = self;
    
    //CloseButton
    [self.closeButton setImage:[UIImage imageNamed:@"Button_Close" inBundle:[FullScreenViewerViewController fullScreenViewerBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
    
    //Arrays
    self.viewsArray = [NSMutableArray new];
    self.videoPlayersArray = [NSMutableArray new];
    
    //Customization
    if(self.pageControlTintColor) {
        self.pageControl.pageIndicatorTintColor = self.pageControlTintColor;
    }
    if(self.pageControlCurrentPageColor) {
        self.pageControl.currentPageIndicatorTintColor = self.pageControlCurrentPageColor;
    }
    
    //Load media
    for(BlazeMediaData *mediaData in self.mediaArray) {
        if(mediaData.mediaType == MediaVideo) {
            //VideoView
            UIView *videoPlayerView = [[UIView alloc] initWithFrame:self.scrollView.bounds];
            [self.scrollView addSubview:videoPlayerView];
            
            //Create player
            AVPlayerViewController *playerViewController = [AVPlayerViewController new];
            
            //Create asset/item
            AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL URLWithString:mediaData.urlStr]];
            AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
            [playerViewController.view setFrame:videoPlayerView.bounds];
            playerViewController.showsPlaybackControls = FALSE;
            
            //Create player
            AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
            playerViewController.player = player;
            
            //Add to view
            [videoPlayerView addSubview:playerViewController.view];
            
            //Play-Button
            UIImage *playImage = [UIImage imageNamed:@"Button_Play" inBundle:[FullScreenViewerViewController fullScreenViewerBundle] compatibleWithTraitCollection:nil];
            UIButton *playButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, playImage.size.width, playImage.size.height)];
            playButton.center = videoPlayerView.center;
            playButton.tag = self.videoPlayersArray.count;
            [playButton setImage:playImage forState:UIControlStateNormal];
            playButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
            [videoPlayerView addSubview:playButton];
            [playButton addTarget:self action:@selector(playTapped:) forControlEvents:UIControlEventTouchUpInside];
            
            //Add view to viewsArray
            [self.viewsArray addObject:videoPlayerView];
            
            //Add videoplayer
            [self.videoPlayersArray addObject:playerViewController];
        }
        else {
            UIScrollView *scrollView = [UIScrollView new];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
            imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [scrollView addSubview:imageView];
            scrollView.minimumZoomScale = 1;
            scrollView.maximumZoomScale = 3;
            scrollView.showsVerticalScrollIndicator = FALSE;
            scrollView.showsHorizontalScrollIndicator = FALSE;
            scrollView.delegate = self;
            
            UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
            [doubleTap setNumberOfTapsRequired:2];
            [scrollView addGestureRecognizer:doubleTap];
            
            [self.scrollView addSubview:scrollView];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            if(mediaData.image) {
                imageView.image = mediaData.image;
            }
            else if(mediaData.data) {
                imageView.image = [UIImage imageWithData:mediaData.data];
            }
            else if(mediaData.urlStr.length) {
                [imageView setImageWithURL:[NSURL URLWithString:mediaData.urlStr] placeholderImage:nil];
            }
            else if(mediaData.name.length) {
                imageView.image = [UIImage imageNamed:mediaData.name];
            }
            
            //Add view to viewsArray
            [self.viewsArray addObject:scrollView];
        }
    }
    
    //PageControl
    self.pageControl.numberOfPages = self.mediaArray.count;
    self.pageControl.currentPage = self.selectedIndex;
    if(self.mediaArray.count == 1) {
        self.pageControl.hidden = TRUE;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.showedIndex) {
        self.scrollView.alpha = 0.0f;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(!self.showedIndex) {
        self.scrollView.contentOffset = CGPointMake(self.selectedIndex*self.scrollView.frame.size.width, 0);
        self.showedIndex = TRUE;
        [UIView animateWithDuration:0.2f animations:^{
            self.scrollView.alpha = 1.0f;
        }];
    }
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    //Width & height
    float width = self.scrollView.frame.size.width;
    float height = self.scrollView.frame.size.height;
    
    //ImageView frames
    for(int i = 0; i < self.viewsArray.count; i++) {
        UIView *view = self.viewsArray[i];
        view.frame = CGRectMake(i*width, 0, width, height);
    }
    
    //ContentSize
    self.scrollView.contentSize = CGSizeMake(self.viewsArray.count*width, height);
}

#pragma mark - Handy creation methods

+(FullScreenViewerViewController *)fullScreenViewerWithMediaData:(NSArray <BlazeMediaData *> *)mediaArray
{
    return [self fullScreenViewerWithMediaData:mediaArray index:0];
}

+(FullScreenViewerViewController *)fullScreenViewerWithMediaData:(NSArray <BlazeMediaData *> *)mediaArray index:(int)index
{
    FullScreenViewerViewController *vc = [[UIStoryboard storyboardWithName:@"FullScreenViewer" bundle:[self fullScreenViewerBundle]] instantiateViewControllerWithIdentifier:@"FullScreenViewerViewController"];
    vc.selectedIndex = index;
    vc.mediaArray = mediaArray;
    return vc;
}

+(void)showFullScreenViewerFromViewController:(UIViewController *)viewController mediaData:(NSArray <BlazeMediaData *> *)mediaArray
{
    return [self showFullScreenViewerFromViewController:viewController mediaData:mediaArray index:0];
}

+(void)showFullScreenViewerFromViewController:(UIViewController *)viewController mediaData:(NSArray <BlazeMediaData *> *)mediaArray index:(int)index
{
    FullScreenViewerViewController *vc = [self fullScreenViewerWithMediaData:mediaArray index:index];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [viewController presentViewController:vc animated:TRUE completion:nil];
    CFRunLoopWakeUp(CFRunLoopGetCurrent());
}

+(NSBundle *)fullScreenViewerBundle
{
    return [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"BlazeFullScreenViewer" ofType:@"bundle"]];
}

#pragma mark - Actions

-(IBAction)closeTapped:(id)sender
{
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

-(void)playTapped:(UIButton *)sender
{
    int tag = (int)sender.tag;
    
    if(tag >= self.videoPlayersArray.count) {
        return;
    }
    
    AVPlayerViewController *smallVC = self.videoPlayersArray[tag];
    
    //Create player
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:smallVC.player.currentItem.asset];
    AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:item];
    playerViewController.player = player;
    
    //Present & Play
    [self presentViewController:playerViewController animated:TRUE completion:^{
        [playerViewController.player play];
    }];
}

-(void)updateViewsForPlaying:(BOOL)playing
{
    [UIView animateWithDuration:0.2f animations:^{
        self.pageControl.alpha = !playing;
        self.closeButton.alpha = !playing;
    }];
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView != self.scrollView) {
        return;
    }
    
    //Update page-control
    self.pageControl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    //Reset possibly zoomed in scrollviews
    for(int i = 0; i < self.viewsArray.count; i++) {
        if(i == self.pageControl.currentPage) {
            continue;
        }
        
        UIView *view = self.viewsArray[i];
        if(![view isKindOfClass:[UIScrollView class]]) {
            continue;
        }
        
        UIScrollView *scrollView = (UIScrollView *)view;
        if(scrollView.zoomScale <= 1.0f) {
            continue;
        }
        
        scrollView.zoomScale = 1.0f;
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollView) {
        return nil;
    }
    
    for(UIView *v in scrollView.subviews) {
        if([v isKindOfClass:[UIImageView class]]) {
            return v;
        }
    }
    return nil;
}

-(void)handleDoubleTap:(UITapGestureRecognizer*)recognizer
{
    UIScrollView *scrollView = (UIScrollView *)recognizer.view;
    
    //Check if we need to zoom in or out
    if(scrollView.zoomScale > 1.0) {
        //Zoom out
        [scrollView setZoomScale:1.0f animated:YES];
    }
    else {
        //Zoom in
        CGPoint touch = [recognizer locationInView:recognizer.view];
        
        CGSize scrollViewSize = scrollView.bounds.size;
        
        CGFloat w = scrollViewSize.width / 3.0f;
        CGFloat h = scrollViewSize.height / 3.0f;
        CGFloat x = touch.x-(w/2.0);
        CGFloat y = touch.y-(h/2.0);
        
        CGRect rectTozoom = CGRectMake(x, y, w, h);
        [scrollView zoomToRect:rectTozoom animated:YES];
    }
}

@end




















