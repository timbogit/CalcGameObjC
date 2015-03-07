//
//  ViewController.m
//  CalcGame
//
//  Created by Tim Schmelmer on 3/7/15.
//  Copyright (c) 2015 Tim Schmelmer. All rights reserved.
//

#import "TSCCalcGameViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "TSCEquation.h"

@interface TSCCalcGameViewController ()
@property (nonatomic,strong) AVAudioPlayer     *failSound;
@property (nonatomic,strong) AVAudioPlayer     *applauseSound;
@property (nonatomic,strong) TSCEquation       *equation;
@property (nonatomic,weak)   IBOutlet UILabel  *equationLbel;

@end

@implementation TSCCalcGameViewController


#pragma mark - UIViewController

- (void)loadView {
    self.view = [[UIImageView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"background.jpg"]];
    self.view.userInteractionEnabled = YES;
    
    [self loadSoundEffects];
    /// TODO add the button and equation labels
}

#pragma mark - helper methods

-(void) loadSoundEffects {
    self.failSound = [self loadCAFSound:@"fail-buzzer"];
    self.applauseSound = [self loadCAFSound:@"applause"];
}

-(AVAudioPlayer *) loadCAFSound:(NSString *)sound {
    NSString *fileName = [[NSBundle mainBundle] pathForResource:sound ofType:@"caf"];
    NSURL *url =[NSURL fileURLWithPath:fileName];
    NSError *error;
    AVAudioPlayer *soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if(!soundPlayer) {
        @throw [NSException exceptionWithName:@"SoundFileNotFound"
                                       reason:[NSString stringWithFormat:@"Soundfile %@ not found", sound]
                                     userInfo:nil];
    }
    return soundPlayer;
}

@end
