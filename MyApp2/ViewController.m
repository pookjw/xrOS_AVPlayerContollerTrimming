//
//  ViewController.m
//  MyApp2
//
//  Created by Jinwoo Kim on 5/8/24.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ViewController ()
@end

@implementation ViewController

- (void)loadView {
    __weak typeof(self) weakSelf = self;
    
    UIButton *button = [UIButton systemButtonWithPrimaryAction:[UIAction actionWithTitle:@"Trim" image:nil identifier:nil handler:^(__kindof UIAction * _Nonnull action) {
        AVMutableComposition *mutableComposition = [AVMutableComposition new];
        
        AVMutableCompositionTrack *mutableCompositionTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:0];
        [mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:1];
        
        NSURL *demo0URL = [NSBundle.mainBundle URLForResource:@"0" withExtension:@"mp4"];
        NSURL *demo1URL = [NSBundle.mainBundle URLForResource:@"1" withExtension:@"mp4"];
        
        AVURLAsset *urlAsset0 = [AVURLAsset assetWithURL:demo0URL];
        AVURLAsset *urlAsset1 = [AVURLAsset assetWithURL:demo1URL];
        
        for (AVURLAsset *urlAsset in @[urlAsset0, urlAsset1]) {
            for (AVAssetTrack *track in urlAsset.tracks) {
                if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
                    NSError * _Nullable error = nil;
                    [mutableCompositionTrack insertTimeRange:track.timeRange ofTrack:track atTime:mutableComposition.duration error:&error];
                    assert(error == nil);
                    break;
                }
            }
        }
        
        //
        
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:mutableComposition];
        [mutableComposition release];
        AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        [playerItem release];
        playerViewController.player = player;
        [player release];
        
        [weakSelf presentViewController:playerViewController animated:YES completion:nil];
        [playerViewController beginTrimmingWithCompletionHandler:^(BOOL success) {
            [playerViewController dismissViewControllerAnimated:YES completion:nil];
        }];
        [playerViewController release];
    }]];
    
    self.view = button;
}

@end
