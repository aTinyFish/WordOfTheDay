//
//  ViewController.h
//  WordOfTheDay
//
//  Created by LittleFin on 6/23/14.
//  Copyright (c) 2014 Michael Dattolo. All rights reserved.
//

#import <UIKit/UIKit.h>

@import WordOfTheDayFramework;

@interface ViewController : UIViewController <TFWordOfTheDayFetcherDelegate>

@property (nonatomic, strong) TFWordOfTheDayFetcher *wordOfTheDayFetcher;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *definitionLabel;
@property (nonatomic, strong) NSString *moreInfoURLString;

- (void)refresh;

@end

