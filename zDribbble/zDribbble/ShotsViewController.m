//
//  ViewController.m
//  zDribbble
//
//  Created by Ezequiel França on 6/28/15.
//  Copyright (c) 2015 Ezequiel França. All rights reserved.
//

#import "ShotsViewController.h"

@interface ShotsViewController () {
    int pagina, maxpaginas;
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
                  
    [self loadShots];
                  
    [[NSNotificationCenter defaultCenter] addObserver:self
                                          selector:@selector(handleDidChangeStatusBarOrientationNotification:)
                                          name:UIApplicationDidChangeStatusBarOrientationNotification
                                                             object:nil];
                  
//    refreshControl = [[UIRefreshControl alloc] init];
//    [refreshControl addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
//    [_shotsList addSubview:_refreshControl];
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
    //Nao carregar paginas que nao existem
    if(pagina >= maxpaginas && maxpaginas != 0)
        return;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@", DRIBBBLE_API_URL, [NSNumber numberWithInt:pagina]];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSError *error = nil;
    Root *root = [MTLJSONAdapter modelOfClass:[Root class] fromJSONDictionary:responseObject error:&error];
    
    [shotsArray addObjectsFromArray:[MTLJSONAdapter modelsOfClass:[Shots class] fromJSONArray:root.rootShots error:&error]];
        NSLog(@"%d", pagina);
    if(maxpaginas == 0)
        maxpaginas = [root.rootPages intValue];
        NSLog(@"%@", responseObject);
    [_shotsList reloadData];
    pagina = pagina + 1;
    [_refreshControl endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Alert View
        [self.view setAlpha:0.3];
        [self errorAlert];
        }];
    }

-(void)errorAlert{
    
    JTAlertView *alertView = [[JTAlertView alloc] initWithTitle:@"Ops :(" andImage:nil];
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
    NSLog(@"INDEXPATH %ld", (long)indexPath.row);
    if (indexPath.item < [shotsArray count]){
        ShotsCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"shotCell" forIndexPath:indexPath];
                      
            Shots *shot = [shotsArray objectAtIndex:[indexPath row]];
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
    [self loadShots];
    // TODO: Programmatically inserting a UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Setup the loading view, which will hold the moving graphics
    self.refreshLoadingView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
    self.refreshLoadingView.backgroundColor = [UIColor clearColor];
    
    // Setup the color view, which will display the rainbowed background
    self.refreshColorView = [[UIView alloc] initWithFrame:self.refreshControl.bounds];
    self.refreshColorView.backgroundColor = [UIColor clearColor];
    self.refreshColorView.alpha = 0.30;
    
    // Create the graphic image views
    self.compass_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"olho"]];
    self.compass_spinner = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dribbble"]];
    
    // Add the graphics to the loading view
    [self.refreshLoadingView addSubview:self.compass_background];
    [self.refreshLoadingView addSubview:self.compass_spinner];
    
    // Clip so the graphics don't stick out
    self.refreshLoadingView.clipsToBounds = YES;
    
    // Hide the original spinner icon
    self.refreshControl.tintColor = [UIColor clearColor];
    
    // Add the loading and colors views to our refresh control
    [self.refreshControl addSubview:self.refreshColorView];
    [self.refreshControl addSubview:self.refreshLoadingView];
    
    // Initalize flags
    self.isRefreshIconsOverlap = NO;
    self.isRefreshAnimating = NO;
    
    // When activated, invoke our refresh function
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.shotsList addSubview:self.refreshControl];
}

- (void)refresh:(id)sender{
    
    // -- DO SOMETHING AWESOME (... or just wait 3 seconds) --
    // This is where you'll make requests to an API, reload data, or process information
    [self.shotsList reloadData];
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // When done requesting/reloading/processing invoke endRefreshing, to close the control
        [self.refreshControl endRefreshing];
    });
    // -- FINISHED SOMETHING AWESOME, WOO! --
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Get the current size of the refresh controller
    CGRect refreshBounds = self.refreshControl.bounds;
    
    // Distance the table has been pulled >= 0
    CGFloat pullDistance = MAX(0.0, -self.refreshControl.frame.origin.y);
    
    // Half the width of the table
    CGFloat midX = self.shotsList.frame.size.width / 2.0;
    
    // Calculate the width and height of our graphics
    CGFloat compassHeight = self.compass_background.bounds.size.height;
    CGFloat compassHeightHalf = compassHeight / 2.0;
    
    CGFloat compassWidth = self.compass_background.bounds.size.width;
    CGFloat compassWidthHalf = compassWidth / 2.0;
    
    CGFloat spinnerHeight = self.compass_spinner.bounds.size.height;
    CGFloat spinnerHeightHalf = spinnerHeight / 2.0;
    
    CGFloat spinnerWidth = self.compass_spinner.bounds.size.width;
    CGFloat spinnerWidthHalf = spinnerWidth / 2.0;
    
    // Calculate the pull ratio, between 0.0-1.0
    CGFloat pullRatio = MIN( MAX(pullDistance, 0.0), 100.0) / 100.0;
    
    // Set the Y coord of the graphics, based on pull distance
    CGFloat compassY = pullDistance / 2.0 - compassHeightHalf;
    CGFloat spinnerY = pullDistance / 2.0 - spinnerHeightHalf;
    
    // Calculate the X coord of the graphics, adjust based on pull ratio
    CGFloat compassX = (midX + compassWidthHalf) - (compassWidth * pullRatio);
    CGFloat spinnerX = (midX - spinnerWidth - spinnerWidthHalf) + (spinnerWidth * pullRatio);
    
    // When the compass and spinner overlap, keep them together
    if (fabs(compassX - spinnerX) < 1.0) {
        self.isRefreshIconsOverlap = YES;
    }
    
    // If the graphics have overlapped or we are refreshing, keep them together
    if (self.isRefreshIconsOverlap || self.refreshControl.isRefreshing) {
        compassX = midX - compassWidthHalf;
        spinnerX = midX - spinnerWidthHalf;
    }
    
    // Set the graphic's frames
    CGRect compassFrame = self.compass_background.frame;
    compassFrame.origin.x = compassX;
    compassFrame.origin.y = compassY;
    
    CGRect spinnerFrame = self.compass_spinner.frame;
    spinnerFrame.origin.x = spinnerX;
    spinnerFrame.origin.y = spinnerY;
    
    self.compass_background.frame = compassFrame;
    self.compass_spinner.frame = spinnerFrame;
    
    // Set the encompassing view's frames
    refreshBounds.size.height = pullDistance;
    
    self.refreshColorView.frame = refreshBounds;
    self.refreshLoadingView.frame = refreshBounds;
    
    // If we're refreshing and the animation is not playing, then play the animation
    if (self.refreshControl.isRefreshing && !self.isRefreshAnimating) {
        [self animateRefreshView];
    }
}

- (void)animateRefreshView
{
    // Background color to loop through for our color view
    NSArray *colorArray = @[[UIColor redColor],[UIColor blueColor],[UIColor purpleColor],[UIColor cyanColor],[UIColor orangeColor],[UIColor magentaColor]];
    static int colorIndex = 0;
    
    // Flag that we are animating
    self.isRefreshAnimating = YES;
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
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
    // Reset our flags and background color
    self.isRefreshAnimating = NO;
    self.isRefreshIconsOverlap = NO;
    self.refreshColorView.backgroundColor = [UIColor clearColor];
}

              
- (IBAction)infoButtonClick:(id)sender {
    NSLog(@"Teste");
    JTAlertView *alertView = [[JTAlertView alloc] initWithTitle:@"Teste desenvolvido para Netshoes - Github @ezefranca" andImage:[UIImage imageNamed:@"netshoes"]];
    alertView.size = CGSizeMake(280, 230);
    [alertView addButtonWithTitle:@"OK" style:JTAlertViewStyleDefault action:^(JTAlertView *alertView) {
        [alertView hide];
    }];
    
    [alertView show];
}
@end