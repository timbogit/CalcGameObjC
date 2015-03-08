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
#import "TSCEquationLabel.h"
#import "NSMutableArray+TSCShuffling.h"

static NSUInteger const NUMBER_OF_ANSWERS = 9;
//static NSIndexSet *const ANSWER_INDEXES [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,9)];
//static NSMutableArray   *const ANSWER_RANGE = 0..((BUTTONS + 1) * 2)

@interface TSCCalcGameViewController ()
@property (nonatomic,strong) AVAudioPlayer     *failSound;
@property (nonatomic,strong) AVAudioPlayer     *applauseSound;
@property (nonatomic,strong) TSCEquation       *equation;
@property (nonatomic,weak)   IBOutlet UILabel  *equationLabel;
@property (nonatomic,strong) NSMutableArray    *buttons;

@end

@implementation TSCCalcGameViewController


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"background.jpg"]];
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    self.view.userInteractionEnabled = YES;
    
    [self loadSoundEffects];
    // Adding the equation label
    self.equation = [[TSCEquation alloc] init];
    [self addEquationLabel];
    
    /// TODO add the buttons
    self.buttons = [[NSMutableArray alloc] init];
    [self addRandomButtons];
}

#pragma mark - Button action handlers

-(void)failureButtonTapped:(UIButton *)sender {
    [self.failSound play];
}

-(void)successButtonTapped:(UIButton *)sender {
    [self.applauseSound play];
}


#pragma mark - helper methods

-(NSArray *)answerRange {
    static NSMutableArray *answers;
    if (!answers) {
        answers = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ANSWERS];
        for (int i=0; i < (NUMBER_OF_ANSWERS + 1) * 2; i++) {
            answers[i] = [NSNumber numberWithInt:i];
        }
    }
    return answers;
}

-(void)addEquationLabel {
    UILabel *eqLabel = [[TSCEquationLabel alloc] initWithParentView:self.view
                                                           equation:self.equation];
    self.equationLabel = eqLabel;
    [self.view addSubview:eqLabel];
}

-(void)addRandomButtons {
    NSMutableArray *randomValues = [[self answerRange] mutableCopy];
    [randomValues tsc_shuffle];
    randomValues = [[randomValues subarrayWithRange:NSMakeRange(0, NUMBER_OF_ANSWERS)] mutableCopy];
    [randomValues addObject: self.equation.result];
    NSArray *allValues = [[NSSet setWithArray:randomValues] allObjects];
    NSUInteger winnerPosition = [allValues indexOfObject:self.equation.result];
    
    for (int pos=0; pos < NUMBER_OF_ANSWERS; pos++) {
        BOOL winner = (pos == winnerPosition);
        self.buttons[pos] = [self makeButtonAtPosition:pos
                                             withValue:[NSString stringWithFormat:@"%@", allValues[pos]]
                                            forSuccess:winner];
        [self.view addSubview:self.buttons[pos]];
    }
    
}

-(UIButton *)makeButtonAtPosition:(NSUInteger)pos
                        withValue:(NSString *)value
                       forSuccess:(BOOL)success {
    NSUInteger margin = 10, top_y = 150;
    NSUInteger width, height;
    width = height = (self.view.frame.size.width - margin * 4) / 3;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    SEL actionForTapping = success ? @selector(successButtonTapped:) : @selector(failureButtonTapped:);
    [button setTitle:value forState:UIControlStateNormal];
    [button addTarget:self action:actionForTapping forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake((pos % 3) * (margin + width) + margin, top_y + ((pos / 3) * (margin + height)), width, height);

    return button;
}

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
