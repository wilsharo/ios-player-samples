//
//  ViewController.m
//  BasicSidecarSubtitlesPlayer
//
//  Copyright (c) 2015 Brightcove, Inc. All rights reserved.
//  License: https://accounts.brightcove.com/en/terms-and-conditions
//

#import "ViewController.h"
#import "BCOVPlayerSDK.h"

#import "BCOVSidecarSubtitles.h"

@import MediaPlayer;
@import AVFoundation;
@import AVKit;

// ** Customize these values with your own account information **
static NSString * const kViewControllerPlaybackServicePolicyKey = @"BCpkADawqM1Sh_RsWQTEtCCpMbpKrbKQN_lhGY3fSZE-Cbp67h2aDRTDuifFXnT3yEYrxPNy640VTr224uWjtky-6YDzzqIDRyjqZq_wXu4Py0MSUMdf2rPmS102D6QGi8bIEQEXutS-eeVp";
static NSString * const kViewControllerAccountID = @"3636334180001";
static NSString * const kViewControllerVideoID = @"3636334180001";

@interface ViewController () <BCOVPlaybackControllerDelegate>

@property (nonatomic, strong) BCOVPlaybackService *service;
@property (nonatomic, strong) id<BCOVPlaybackController> playbackController;

@property (nonatomic, weak) IBOutlet UIView *videoContainer;
@property (nonatomic, strong) AVPlayerViewController *playerViewController;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    BCOVPlayerSDKManager *manager = [BCOVPlayerSDKManager sharedManager];

    _playbackController = [manager createSidecarSubtitlesPlaybackControllerWithViewStrategy:[manager defaultControlsViewStrategy]];
    _playbackController.delegate = self;
    _playbackController.autoAdvance = YES;
    _playbackController.autoPlay = YES;
    
    _service = [[BCOVPlaybackService alloc] initWithAccountId:kViewControllerAccountID policyKey:kViewControllerPlaybackServicePolicyKey];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.playbackController.view.frame = self.videoContainer.bounds;
    self.playbackController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.videoContainer addSubview:self.playbackController.view];
    
    [self requestContentFromPlaybackService];
    
}

- (void)requestContentFromPlaybackService
{
    [self.service findVideoWithVideoID:kViewControllerVideoID parameters:nil completion:^(BCOVVideo *video, NSDictionary *jsonResponse, NSError *error) {
        
        [self.playbackController setVideos:@[ video ]];
        
    }];
}


#pragma mark BCOVPlaybackControllerDelegate Methods

- (void)playbackController:(id<BCOVPlaybackController>)controller playbackSession:(id<BCOVPlaybackSession>)session didReceiveLifecycleEvent:(BCOVPlaybackSessionLifecycleEvent *)lifecycleEvent
{
    NSLog(@"ViewController Debug - Received lifecycle event.");
}


#pragma mark UI Styling

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
