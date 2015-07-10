//
//  DetalhesViewController.m
//  zDribbble
//
//  Created by Ezequiel on 6/29/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import "DetalhesViewController.h"
#import <Social/Social.h>

@interface DetalhesViewController ()

@end

@implementation DetalhesViewController
@synthesize shot, jbWebview;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTouchShot];
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

-(void)setupTouchShot{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShot)];
    tap.numberOfTapsRequired = 1;
    [_shotImage setUserInteractionEnabled:YES];
    [_shotImage addGestureRecognizer:tap];
    

}

-(void)tapShot{
   jbWebview = [[JBWebViewController alloc] initWithUrl:[shot shotUrl]];
   [jbWebview show];
    
}


#pragma mark - SHARE BUTTONS

- (IBAction)shareShotFacebook:(id)sender {
    
    
    SLComposeViewController *socialController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [socialController setInitialText:[shot shotTitle]];
    [socialController addImage:_shotImage.image];
    [socialController addURL:[shot shotUrl]];
    [self presentViewController:socialController animated:YES completion:nil];

}

- (IBAction)shareShotTwitter:(id)sender {
    
    
    SLComposeViewController *socialController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [socialController setInitialText:[shot shotTitle]];
    [socialController addImage:_shotImage.image];
    [socialController addURL:[shot shotUrl]];
    [self presentViewController:socialController animated:YES completion:nil];
    
}
@end
