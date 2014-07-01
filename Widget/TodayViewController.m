//
//  TodayViewController.m
//  Widget
//
//  Created by LittleFin on 6/23/14.
//  Copyright (c) 2014 Michael Dattolo. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController
//

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setDefaults];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    TFWordOfTheDayFetcher *wordFetcher = [TFWordOfTheDayFetcher new];
    
    // Check and see if we've already fetched the definition for today
    // If we have, we load it from NSUserDefaults
    // If not, we'll trigger a fetch from the web and get the new data when we have it
    
    if ([wordFetcher wordHasBeenFetchedForDate:[NSDate date]]) {

        NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.aTinyFish.WordOfTheDay"];
        NSString *wordOfTheDay = [sharedDefaults objectForKey:@"TodaysWord"];
        
        if ([wordOfTheDay isEqualToString:self.widgetTitleLabel.text]) {
            
            // We don't need to update the word of the day.
            NSLog(@"No update needed");
            self.wordOfTheDay = nil;
            
        } else {
            NSLog(@"Loading from saved");
            self.wordOfTheDay = [TFWordOfTheDay new];
            self.wordOfTheDay.word = [sharedDefaults objectForKey:@"TodaysWord"];
            self.wordOfTheDay.definition = [sharedDefaults objectForKey:@"TodaysDefinition"];
            self.wordOfTheDay.date = [sharedDefaults objectForKey:@"LastFetchDate"];
            self.wordOfTheDay.urlString = [sharedDefaults objectForKey:@"TodaysURL"];
            self.widgetTitleLabel.text = self.wordOfTheDay.word;
            self.widgetDefinitionLabel.text = self.wordOfTheDay.definition;
            [self.view setNeedsDisplay];
        }
        
        
    } else {
        NSLog(@"Fetching from web");
        self.wordOfTheDayFetcher = [TFWordOfTheDayFetcher new];
        self.wordOfTheDayFetcher.delegate = self;
        [self.wordOfTheDayFetcher refreshWordOfTheDayForDate:[NSDate date] withIdentifier:@"com.atinyfish.wordoftheday.widget.backgroundsession"];
    }
    
}


- (void)setDefaults {
    
    // Default values for the definition defaults container
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.aTinyFish.WordOfTheDay"];
    
    NSDictionary *defaults = @{@"TodaysWord" : @"squirrelly",
                               @"TodaysDefinition" : @"Restless, jumpy, nervy.",
                               @"TodaysURL" : @"http://wordsmith.org/words/squirrelly.html",
                               @"LastFetchDate" : [NSDate distantPast],
                               };
    
    [sharedDefaults registerDefaults:defaults];

}

- (IBAction)readMore:(id)sender {
    
    NSLog(@"Launching Main App");
    [self.extensionContext openURL:[NSURL URLWithString:@"fishwordofthedayapp://"] completionHandler:nil];
}

- (void)newWordOfTheDayReceived:(TFWordOfTheDay *)wordOfTheDay
{
    NSLog(@"New Word Received: %@ %@", wordOfTheDay.word, wordOfTheDay.definition);
    self.wordOfTheDay = wordOfTheDay;
 
    self.widgetTitleLabel.text = wordOfTheDay.word;
    self.widgetDefinitionLabel.text = wordOfTheDay.definition;
    [self.view setNeedsDisplay];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encoutered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    if (self.wordOfTheDay) {
        NSLog(@"New Data");
        self.widgetTitleLabel.text = self.wordOfTheDay.word;
        self.widgetDefinitionLabel.text = self.wordOfTheDay.definition;
        [self.view setNeedsDisplay];
        completionHandler(NCUpdateResultNewData);
        
    } else {
        
        NSLog(@"No New Data");
        completionHandler(NCUpdateResultNoData);
    }
    
}

- (void)updateSize
{
//    CGSize preferredSize = self.preferredContentSize;
//    preferredSize.height = 200;
//    self.preferredContentSize = preferredSize;
}


@end
