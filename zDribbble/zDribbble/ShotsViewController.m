//
//  ViewController.m
//  zDribbble
//
//  Created by Ezequiel França on 6/28/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import "ShotsViewController.h"

@interface ShotsViewController () {
    int page, maxPages;
    NSMutableArray *shotsList;
    UIRefreshControl *refreshControl;
}


@end

@implementation ShotsViewController

#pragma mark - Ciclo de vida
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setTitle:@"zDribbble"];
                  
    page = 1;
                  
    shotsList = [[NSMutableArray alloc] init];
                  
    [self loadShots];
                  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(handleDidChangeStatusBarOrientationNotification:)
                                          name:UIApplicationDidChangeStatusBarOrientationNotification
                                                             object:nil];
                  
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    [_shotsList addSubview:refreshControl];
    [_shotsList setAlwaysBounceVertical:YES];
                  
                  
}
              
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
              
#pragma mark - Methods
- (void)pullToRefresh {
    page = 1;
    shotsList = [[NSMutableArray alloc] init];
                  
    [self loadShots];
}
              
- (void)loadShots {
    if(page >= maxPages && maxPages != 0) return;
                  
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                  
    [manager GET:@"http://api.dribbble.com/shots/popular" parameters:@{@"page" : [NSNumber numberWithInt:page]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
    if(maxPages == 0) maxPages = (int)[[responseObject objectForKey:@"pages"] integerValue];
                      
    [shotsList addObjectsFromArray:[MTLJSONAdapter modelsOfClass:[Shots class] fromJSONArray:[responseObject objectForKey:@"shots"] error:nil]];
                      
    [_shotsList reloadData];
                      
    page += 1;
                      
    [refreshControl endRefreshing];
                      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      //TODO
                      
        }];
    }


// Redimensionar a tela para cada device ou orientacao
-(CGSize)resizeCollectionCells {
    int width = [[UIScreen mainScreen] bounds].size.width;
    
        CGSize size;
                  
        switch (width) {
        case 320:
                size = CGSizeMake(305, 229);
                break;
        case 375:
                size = CGSizeMake(360, 270);
                break;
        case 480:
                size = CGSizeMake(228, 171);
                break;
        case 568:
                size = CGSizeMake(270, 203);
                break;
        case 667:
                size = CGSizeMake(320, 240);
                break;
        case 736:
                size = CGSizeMake(352, 265);
                break;
        case 768:
                size = CGSizeMake(367, 265);
                break;
        case 1024:
                size = CGSizeMake(495, 371);
                break;
        default:
                size = CGSizeMake(400, 300);
                break;
    }
                  
    return size;
}
              
- (void)handleDidChangeStatusBarOrientationNotification:(NSNotification *)notification;{
        [_shotsList reloadData];
}
              
#pragma mark - CollectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if(page < maxPages){
        return [shotsList count] + 1;
    }else{
        return [shotsList count];
    }
}
              
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
                  
    if (indexPath.item < [shotsList count]){
        ShotsCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shotCell" forIndexPath:indexPath];
                      
            Shots *shot = [shotsList objectAtIndex:[indexPath row]];
                      
            [[cell Image] sd_setImageWithURL:[shot shotImage400Url]];
            [[cell Title] setText:[shot shotTitle]];
            [[cell ViewsCount] setText:[NSString stringWithFormat:@"%@", [shot shotViewsCount]]];
        
            return cell;
        return nil;
    }else{
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"loadingCell" forIndexPath:indexPath];
                      
        [self loadShots];
        return cell;
    }
}
              
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
                  
//    DetailViewController *detail = [[self storyboard] instantiateViewControllerWithIdentifier:@"viewDetail"];
//    [detail setShot:[shotsList objectAtIndex:[indexPath row]]];
//    [[self navigationController] pushViewController:detail animated:YES];

}
              
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
                  
    return [self resizeCollectionCells];
                  
}
              
@end