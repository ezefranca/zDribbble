//
//  ViewController.m
//  zDribbble
//
//  Created by Ezequiel França on 6/28/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import "ShotsViewController.h"
#import "MBLoadingIndicator.h"

@interface ShotsViewController () {
    int pagina, maxpaginas;
    MBLoadingIndicator *load;
}
@end

@implementation ShotsViewController

@synthesize shotsArray;

#pragma mark - Ciclo de vida
- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self customize];
    self.flowLayout = [[FlowLayout alloc]init];
    self.shotsList.collectionViewLayout = self.flowLayout;
    [self setupRefreshControl];
    [self setTitle:@"zDribbble"];
                  
    pagina = 1;
                  
    shotsArray = [[NSMutableArray alloc] init];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(handleDidChangeStatusBarOrientationNotification:)
                                          name:UIApplicationDidChangeStatusBarOrientationNotification
                                                             object:nil];

    [_shotsList setAlwaysBounceVertical:YES];
}
              
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)customize{
    UIImage *image = [UIImage imageNamed:@"navbar"];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
}
              
#pragma mark - Methods

- (void)loadShots {
    
    if (pagina == 1) {
    load = [[MBLoadingIndicator alloc] init];
    [load start];
    [self.view addSubview:load];
    
    }
    //Nao carregar paginas que nao existem
    if(pagina >= maxpaginas && maxpaginas != 0)
        return;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@", DRIBBBLE_API_URL, [NSNumber numberWithInt:pagina]];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSError *error = nil;
    Root *root = [MTLJSONAdapter modelOfClass:[Root class] fromJSONDictionary:responseObject error:&error];
    
    [shotsArray addObjectsFromArray:[MTLJSONAdapter modelsOfClass:[Shots class] fromJSONArray:root.rootShots error:&error]];
    if(maxpaginas == 0)
        maxpaginas = [root.rootPages intValue];
    [_shotsList reloadData];
    pagina = pagina + 1;
    [_refreshControl endRefreshing];
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view setAlpha:0.3];
        [self errorAlert:error];
        }];
    
    if (pagina == 1)
    [load finish];
}

-(void)errorAlert:(NSError *)error{
    
    NSString *title = [NSString stringWithFormat:@"Ops! %@", error.description];
    JTAlertView *alertView = [[JTAlertView alloc] initWithTitle:title andImage:nil];
    alertView.size = CGSizeMake(280, 230);
    [alertView addButtonWithTitle:@"OK" style:JTAlertViewStyleDefault action:^(JTAlertView *alertView) {
        [alertView hide];
    }];
    
    [alertView show];
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
    if(pagina < maxpaginas){
        return [shotsArray count] + 1;
    }else{
        return [shotsArray count];
    }
}
              
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item < [shotsArray count]){
        ShotsCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shotCell" forIndexPath:indexPath];
                      
            Shots *shot = [shotsArray objectAtIndex:[indexPath row]];
            if (shot.shotImage400Url) {
                  [[cell Image] sd_setImageWithURL:[shot shotImage400Url]];
            }else{
                  [[cell Image] sd_setImageWithURL:[shot shotImageUrl]];
            }
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
                  
       DetalhesViewController *detalhesVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"detalhes"];
       [detalhesVC setShot:[shotsArray objectAtIndex:indexPath.row]];
       detalhesVC.shot = [shotsArray objectAtIndex:[indexPath row]];
      [[self navigationController] pushViewController:detalhesVC animated:YES];

}
              
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //return self.shotsList.frame.size;
    return [self resizeCollectionCells];
                  
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(    NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.shotsList reloadData];
}


#pragma mark - PULL TO REFRESH

- (void)setupRefreshControl
{
    pagina = 1;
    shotsArray = [[NSMutableArray alloc] init];
  
    self.refreshControl = [[UIRefreshControl alloc] init];
    
 
    self.refreshLoadingView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
    self.refreshLoadingView.backgroundColor = [UIColor clearColor];
    self.refreshColorView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
    self.refreshColorView.backgroundColor = [UIColor clearColor];
    self.refreshColorView.alpha = 0.30;
    
  
    self.compass_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dribbble"]];
    self.compass_spinner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dribbble"]];
    

    [self.refreshLoadingView addSubview:self.compass_background];
    [self.refreshLoadingView addSubview:self.compass_spinner];

    self.refreshLoadingView.clipsToBounds = YES;
    self.refreshControl.tintColor = [UIColor clearColor];
    [self.refreshControl addSubview:self.refreshColorView];
    [self.refreshControl addSubview:self.refreshLoadingView];
    
   
    self.isRefreshIconsOverlap = NO;
    self.isRefreshAnimating = NO;
    
    [self loadShots];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.shotsList addSubview:self.refreshControl];
}

- (void)refresh:(id)sender{
    
    [self.shotsList reloadData];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.refreshControl endRefreshing];
    });
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    CGRect refreshBounds = self.refreshControl.bounds;
    CGFloat pullDistance = MAX(0.0, -self.refreshControl.frame.origin.y);
    CGFloat midX = self.shotsList.frame.size.width / 2.0;
    CGFloat compassHeight = self.compass_background.bounds.size.height;
    CGFloat compassHeightHalf = compassHeight / 2.0;
    
    CGFloat compassWidth = self.compass_background.bounds.size.width;
    CGFloat compassWidthHalf = compassWidth / 2.0;
    
    CGFloat spinnerHeight = self.compass_spinner.bounds.size.height;
    CGFloat spinnerHeightHalf = spinnerHeight / 2.0;
    
    CGFloat spinnerWidth = self.compass_spinner.bounds.size.width;
    CGFloat spinnerWidthHalf = spinnerWidth / 2.0;

    CGFloat pullRatio = MIN( MAX(pullDistance, 0.0), 100.0) / 100.0;
    
    CGFloat compassY = pullDistance / 2.0 - compassHeightHalf;
    CGFloat spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
    
    CGFloat compassX = (midX + compassWidthHalf) - (compassWidth * pullRatio);
    CGFloat spinnerX = (midX - spinnerWidth - spinnerWidthHalf) + (spinnerWidth * pullRatio);
    
    if (fabs(compassX - spinnerX) < 1.0) {
        self.isRefreshIconsOverlap = YES;
    }

    if (self.isRefreshIconsOverlap || self.refreshControl.isRefreshing) {
        compassX = midX - compassWidthHalf;
        spinnerX = midX - spinnerWidthHalf;
    }
    
    CGRect compassFrame = self.compass_background.frame;
    compassFrame.origin.x = compassX;
    compassFrame.origin.y = compassY;
    
    CGRect spinnerFrame = self.compass_spinner.frame;
    spinnerFrame.origin.x = spinnerX;
    spinnerFrame.origin.y = spinnerY;
    
    self.compass_background.frame = compassFrame;
    self.compass_spinner.frame = spinnerFrame;

    refreshBounds.size.height = pullDistance;
    
    self.refreshColorView.frame = refreshBounds;
    self.refreshLoadingView.frame = refreshBounds;

    if (self.refreshControl.isRefreshing && !self.isRefreshAnimating) {
        [self animateRefreshView];
    }
}

- (void)animateRefreshView
{
    NSArray *colorArray = @[[UIColor purpleColor],[UIColor whiteColor],[UIColor cyanColor],[UIColor orangeColor]];
    static int colorIndex = 0;

    self.isRefreshAnimating = YES;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Rotate  M_PI_2 = PI/2 = 90 degrees
                         [self.compass_spinner setTransform:CGAffineTransformRotate(self.compass_spinner.transform, M_PI_2)];
                         
                         // Change the background color
                         self.refreshColorView.backgroundColor = [colorArray objectAtIndex:colorIndex];
                         colorIndex = (colorIndex + 1) % colorArray.count;
                     }
                     completion:^(BOOL finished) {
                         // If still refreshing, keep spinning, else reset
                         if (self.refreshControl.isRefreshing) {
                             [self animateRefreshView];
                         }else{
                             [self resetAnimation];
                         }
                     }];
}

- (void)resetAnimation
{
    self.isRefreshAnimating = NO;
    self.isRefreshIconsOverlap = NO;
    self.refreshColorView.backgroundColor = [UIColor clearColor];
}

              
- (IBAction)infoButtonClick:(id)sender {
    JTAlertView *alertView = [[JTAlertView alloc] initWithTitle:@"Teste desenvolvido para Netshoes - Github @ezefranca" andImage:[UIImage imageNamed:@"netshoes"]];
    alertView.size = CGSizeMake(280, 230);
    [alertView addButtonWithTitle:@"OK" style:JTAlertViewStyleDefault action:^(JTAlertView *alertView) {
        [alertView hide];
    }];
    
    [alertView show];
}
@end