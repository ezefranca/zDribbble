//
//  DetalhesViewController.m
//  zDribbble
//
//  Created by Ezequiel on 6/29/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import "DetalhesViewController.h"

@interface DetalhesViewController ()

@end

@implementation DetalhesViewController
@synthesize shot;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"Shot Detalhes"];
    
    [self.shotImage sd_setImageWithURL:[shot shotImageUrl]];
    [self.shotTitle setText:[shot shotTitle]];
    [self.shotViewCount setText:[NSString stringWithFormat:@"%@",[shot shotViewsCount]]];
    [self.shotDescription setText:[shot shotDescription]];
    
    [self.playerName setText:[[shot shotPlayer] playerName]];
    [self.playerPhoto sd_setImageWithURL:[[shot shotPlayer] playerAvatarUrl]];
    
    [[_playerPhoto layer] setMasksToBounds:YES];
    [[_playerPhoto layer] setCornerRadius:20];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
