//
//  MainViewController.m
//  BrainGame
//
//  Created by Lê Công on 12/18/14.
//  Copyright (c) 2014 Lê Công. All rights reserved.
//

#import "MainViewController.h"
#import "GameViewController.h"
#import "CaculatorGame.h"
#import "GameScene.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)selectGame:(id)sender {
    [self performSegueWithIdentifier:@"SHOW_GAME" sender:sender];
}

- (IBAction)selectGame2:(id)sender {
    [self performSegueWithIdentifier:@"SHOW_GAME" sender:sender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SHOW_GAME"]) {
        int tagIndex = (int)[(UIButton *)sender tag];
        GameViewController *vc = [segue destinationViewController];
        vc.gameType = tagIndex;
    }
}

@end
