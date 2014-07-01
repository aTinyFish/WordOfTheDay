//
//  TodayViewController.h
//  Widget
//
//  Created by LittleFin on 6/23/14.
//  Copyright (c) 2014 Michael Dattolo. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WordOfTheDayFramework;

@interface TodayViewController : UIViewController <TFWordOfTheDayFetcherDelegate>

@property (nonatomic, strong) TFWordOfTheDayFetcher *wordOfTheDayFetcher;
@property (nonatomic, strong) TFWordOfTheDay *wordOfTheDay;
@property (weak, nonatomic) IBOutlet UILabel *widgetTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *widgetDefinitionLabel;

@end
