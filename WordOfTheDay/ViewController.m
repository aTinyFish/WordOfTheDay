//
//  ViewController.m
//  WordOfTheDay
//
//  Created by LittleFin on 6/23/14.
//  Copyright (c) 2014 Michael Dattolo. All rights reserved.
//

#import "ViewController.h"
#import "WordOfTheDayFramework.h"
#import "AppDelegate.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.wordOfTheDayFetcher = [TFWordOfTheDayFetcher new];
    self.wordOfTheDayFetcher.delegate = self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadFromDefaults];
}

- (void)reloadFromDefaults {
    // Load the word of the day from user defaults if it exists
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.aTinyFish.WordOfTheDay"];
    
    self.titleLabel.text = [sharedDefaults objectForKey:@"TodaysWord"];
    self.definitionLabel.text = [sharedDefaults objectForKey:@"TodaysDefinition"];
    self.moreInfoURLString = [sharedDefaults objectForKey:@"TodaysURL"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)refresh
{
    // Check and see if we've already fetched the definition for today
    // If we have, we load it from NSUserDefaults
    // If not, we'll trigger a fetch from the web and get the new data when we have it
    
    if ([self.wordOfTheDayFetcher wordHasBeenFetchedForDate:[NSDate date]]) {
        
        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.aTinyFish.WordOfTheDay"];
        NSString *wordOfTheDay = [sharedDefaults objectForKey:@"TodaysWord"];
        
        if ([wordOfTheDay isEqualToString:self.titleLabel.text]) {
            // We don't need to update the word of the day.
            NSLog(@"No update needed");
            
        } else {
            NSLog(@"Loading from saved");
            [self reloadFromDefaults];
        }
        
        
    } else {
        NSLog(@"Fetching from web");
        [self.wordOfTheDayFetcher refreshWordOfTheDayForDate:[NSDate date] withIdentifier:@"com.atinyfish.wordoftheday.backgroundsession"];
    }

}

- (void)newWordOfTheDayReceived:(TFWordOfTheDay *)wordOfTheDay {

    NSLog(@"New Word Received: %@", wordOfTheDay.word);
    
    // When a new word of the day is downloaded, we update the interface here
    // Update the Interface
    self.titleLabel.text = wordOfTheDay.word;
    self.definitionLabel.text = wordOfTheDay.definition;
    self.moreInfoURLString = wordOfTheDay.urlString;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reset:(id)sender {
    [self.wordOfTheDayFetcher clearSavedData];
    [self reloadFromDefaults];
}

- (IBAction)getMoreInfo:(id)sender {
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.aTinyFish.WordOfTheDay"];
    NSString *moreInfoURLString = [sharedDefaults objectForKey:@"TodaysURL"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:moreInfoURLString]];
    
}

@end
