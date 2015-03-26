//
//  ViewController.m
//  OfficeDogStagram
//
//  Created by Ian MacKinnon on 2015-03-26.
//  Copyright (c) 2015 Ian MacKinnon. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "PuppyCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface ViewController (){
    NSArray *puppyArray;
    UICollectionViewFlowLayout *smallLayout;
    UICollectionViewFlowLayout *bigLayout;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *makeSmallButton = [[UIBarButtonItem alloc] initWithTitle:@"make small" style:UIBarButtonItemStylePlain target:self action:@selector(makeSmall)];
    
    self.navigationItem.rightBarButtonItem = makeSmallButton;
    
    bigLayout = [[UICollectionViewFlowLayout alloc] init];
    bigLayout.itemSize = CGSizeMake(140, 140);
    bigLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    bigLayout.minimumInteritemSpacing = 10.0f;
    bigLayout.minimumLineSpacing = 10.0f;
    bigLayout.headerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 100.f);
    
    smallLayout = [[UICollectionViewFlowLayout alloc] init];
    smallLayout.itemSize = CGSizeMake(40, 40);
    smallLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    smallLayout.minimumInteritemSpacing = 10.0f;
    smallLayout.minimumLineSpacing = 10.0f;
    smallLayout.headerReferenceSize = CGSizeZero;
    
    [self.collectionView setCollectionViewLayout:bigLayout];
    
}


-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [[AFHTTPRequestOperationManager manager] GET:@"https://api.instagram.com/v1/tags/officedogs/media/recent?client_id=531009644bc8430a8ac8404c7d713317" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        puppyArray = [responseObject objectForKey:@"data"];
        
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


-(void) makeSmall{
    
    [smallLayout invalidateLayout];
    [self.collectionView setCollectionViewLayout:smallLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [puppyArray count];
}


-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * instagram = [puppyArray objectAtIndex:indexPath.row];
    
    PuppyCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    
    NSString *url = [[[instagram objectForKey:@"images"] objectForKey:@"low_resolution"] objectForKey:@"url"];
    
    [cell.puppyImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    return cell;
    
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary * instagram = [puppyArray objectAtIndex:indexPath.row];
    
    NSString *caption = [[instagram objectForKey:@"caption"] objectForKey:@"text"];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"caption" message:caption delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    [alertView show];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        UICollectionReusableView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"puppyHeader" forIndexPath:indexPath];
        return headerView;
    }
    return nil;
}


@end
