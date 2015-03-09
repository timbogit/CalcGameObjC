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
#import "NSMutableArray+TSCShufflingAndReversing.h"

static NSUInteger const NUMBER_OF_ANSWERS = 9;

@interface TSCCalcGameViewController ()
@property (nonatomic,strong)        AVAudioPlayer     *failSound;
@property (nonatomic,strong)        AVAudioPlayer     *applauseSound;
@property (nonatomic,strong)        TSCEquation       *equation;
@property (nonatomic,weak) IBOutlet TSCEquationLabel  *equationLabel;
@property (nonatomic,strong)        NSMutableArray    *buttons;
@property (nonatomic,assign)        NSUInteger        score;
@property (nonatomic,assign)        NSUInteger        tries;
@property (nonatomic,weak) IBOutlet UILabel           *scoreLabel;
@property (nonatomic,weak) IBOutlet UILabel           *triesLabel;

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
    [self addEquationLabelAndAnswerButtons];
    [self addScoreAndTriesLabels];
    [self addSwipeLeftToResetScoresAndTries];
}

- (NSUInteger) supportedInterfaceOrientations {
    // On all devices, return portrait or portrait upside-down
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

#pragma mark - Button action handlers

-(void)failureButtonTapped:(UIButton *)sender {
    self.failSound.currentTime = 0.0f;
    [self.failSound play];
    [self updateTriesWithTries:self.tries + 1];
}

-(void)successButtonTapped:(UIButton *)sender {
    [UIView animateWithDuration:1.25
                     animations:^{
                         self.equationLabel.alpha = 0.f;
                         self.equationLabel.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
                         [self.applauseSound play];
                         [self updateTriesWithTries:self.tries + 1];
                     }
                     completion:^(BOOL finished) {
                         self.equationLabel.text =
                            [self.equationLabel.text stringByReplacingOccurrencesOfString:@"?"
                                                                               withString:self.equation.result];
                         [UIView animateWithDuration:1.5f
                                          animations: ^{
                                              self.equationLabel.alpha = 1.f;
                                              self.equationLabel.textColor = [UIColor blueColor];
                                              self.equationLabel.backgroundColor = [UIColor greenColor];
                                              self.equationLabel.transform = CGAffineTransformIdentity;
                                          }
                                          completion: ^(BOOL finished) {
                                              [self removeEquationLabelAndAnswerButtons];
                                              [self addEquationLabelAndAnswerButtons];
                                              [self.applauseSound stop];
                                              self.applauseSound.currentTime = 0.0f;
                                              [self updateScoreWithScore:self.score + 1];
                                          }];
                     }];
}

#pragma mark - gesture recognizer actions

-(void)didSwipeLeft:(UISwipeGestureRecognizer *)sender {
    [self updateScoreWithScore:0];
    [self updateTriesWithTries:0];
}

#pragma mark - helper methods

-(NSArray *)answerRange {
    static NSMutableArray *answers;
    if (!answers) {
        answers = [[NSMutableArray alloc] initWithCapacity:NUMBER_OF_ANSWERS];
        for (int i=0; i < 200; i++) {
            answers[i] = [NSNumber numberWithInt:i];
        }
    }
    return answers;
}


- (void)addSwipeLeftToResetScoresAndTries {
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGestureRecognizer];
}

-(void)addScoreAndTriesLabels {
    NSUInteger margin = 15, width = 80, height = 20;
    UILabel *scoreLabel = [[UILabel alloc]
                           initWithFrame:CGRectMake(self.view.frame.size.width - (width + margin / 2), margin, width, height)];
    scoreLabel.font = [UIFont systemFontOfSize:15.f];
    scoreLabel.textAlignment = NSTextAlignmentLeft;
    scoreLabel.textColor = [UIColor greenColor];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.alpha = 0.90f;
    self.scoreLabel = scoreLabel;
    [self.view addSubview:self.scoreLabel];
    [self updateScoreWithScore:0];

    UILabel *triesLabel = [[UILabel alloc]
                           initWithFrame:CGRectMake(margin / 2, margin, width, height)];
    triesLabel.font = [UIFont systemFontOfSize:15.f];
    triesLabel.textAlignment = NSTextAlignmentLeft;
    triesLabel.textColor = [UIColor lightTextColor];
    triesLabel.backgroundColor = [UIColor clearColor];
    triesLabel.alpha = 0.90f;
    self.triesLabel = triesLabel;
    [self.view addSubview:self.triesLabel];
    [self updateTriesWithTries:0];
}

-(void)updateScoreWithScore:(NSUInteger)score {
    self.score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %lu", (unsigned long)self.score];
}

-(void)updateTriesWithTries:(NSUInteger)tries {
    self.tries = tries;
    self.triesLabel.text = [NSString stringWithFormat:@"Tires: %lu", (unsigned long)self.tries];
}

-(void)addEquationLabelAndAnswerButtons {
    self.equation = [[TSCEquation alloc] init];
    [self addEquationLabel];

    self.buttons = [[NSMutableArray alloc] init];
    [self addRandomButtons];
}

-(void)addEquationLabel {
    TSCEquationLabel *eqLabel = [[TSCEquationLabel alloc] initWithParentView:self.view
                                                           equation:self.equation];
    self.equationLabel = eqLabel;
    [self.view addSubview:eqLabel];
}

-(void)addRandomButtons {
    NSMutableArray *randomValues = [[self answerRange] mutableCopy];
    [randomValues tsc_shuffle];
    randomValues = [[randomValues subarrayWithRange:NSMakeRange(0, NUMBER_OF_ANSWERS - 1)] mutableCopy];
    [randomValues addObject: self.equation.resultAsNumber];
    [randomValues tsc_shuffle];
    
    for (int pos=0; pos < NUMBER_OF_ANSWERS; pos++) {
        BOOL winner = [randomValues[pos] isEqualToNumber:self.equation.resultAsNumber];
        self.buttons[pos] = [self makeButtonAtPosition:pos
                                             withValue:[NSString stringWithFormat:@"%@", randomValues[pos]]
                                            forSuccess:winner];
        [self.view addSubview:self.buttons[pos]];
    }
    
}

-(void)removeEquationLabelAndAnswerButtons {
    if (self.equationLabel) {
        [self.equationLabel removeFromSuperview];
    }
    self.equationLabel = nil;

    for (int i=0; i < [self.buttons count]; i++) {
        if (self.buttons[i]) {
            [self.buttons[i] removeFromSuperview];
            self.buttons[i] = [NSNull null] ;
        }
    }
    self.buttons = nil;
}

-(UIButton *)makeButtonAtPosition:(NSUInteger)pos
                        withValue:(NSString *)value
                       forSuccess:(BOOL)success {
    NSUInteger margin = 10, top_y = 150;
    NSUInteger width, height;
    width = height = (self.view.frame.size.width - margin * 4) / 3;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.backgroundColor = [UIColor grayColor];
    button.alpha = 0.75f;
    button.titleLabel.font = [UIFont systemFontOfSize:30.f];
    button.titleLabel.alpha = 1.0f;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
