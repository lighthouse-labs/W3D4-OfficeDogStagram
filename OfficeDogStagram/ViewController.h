//
//  ViewController.h
//  OfficeDogStagram
//
//  Created by Ian MacKinnon on 2015-03-26.
//  Copyright (c) 2015 Ian MacKinnon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;

@end

