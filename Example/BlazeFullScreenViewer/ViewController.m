//
//  ViewController.m
//  BlazeFullScreenViewer
//
//  Created by Bob de Graaf on 30-10-17.
//  Copyright © 2017 GraafICT. All rights reserved.
//

#import "BlazeMediaData.h"
#import "ViewController.h"
#import "FullScreenViewerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
}
    
-(IBAction)imageTapped:(UIButton *)sender
{
    //Simple
    [FullScreenViewerViewController showFullScreenViewerFromViewController:self mediaData:[self blazeMediaData] index:(int)sender.tag];
    
    //Advanced customization
//    FullScreenViewerViewController *vc = [FullScreenViewerViewController fullScreenViewerWithMediaData:[self blazeMediaData] index:(int)sender.tag];
//    vc.pageControlTintColor = [UIColor redColor];
//    vc.pageControlCurrentPageColor = [UIColor blueColor];
//    [self presentViewController:vc animated:TRUE completion:nil];
//    CFRunLoopWakeUp(CFRunLoopGetCurrent());
}

-(NSArray <BlazeMediaData *> *)blazeMediaData
{
    return @[[BlazeMediaData mediaDataWithName:@"Image_1"],
             [BlazeMediaData mediaDataWithName:@"Image_2"],
             [BlazeMediaData mediaDataWithName:@"Image_3"],
             [BlazeMediaData mediaDataWithName:@"Image_4"],
             ];
}


@end
