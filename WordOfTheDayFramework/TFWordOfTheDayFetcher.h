//
//  TFWordOfTheDayFetcher.h
//  WordOfTheDay
//
//  Created by LittleFin on 6/23/14.
//  Copyright (c) 2014 Michael Dattolo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFWordOfTheDay.h"

@protocol TFWordOfTheDayFetcherDelegate <NSObject>

- (void)newWordOfTheDayReceived:(TFWordOfTheDay *)wordOfTheDay;

@optional

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session;

@end

@interface TFWordOfTheDayFetcher : NSObject

@property (nonatomic, strong) id <TFWordOfTheDayFetcherDelegate> delegate;

- (BOOL)wordHasBeenFetchedForDate:(NSDate *)date;
- (void)refreshWordOfTheDayForDate:(NSDate *)date withIdentifier:(NSString *)identifier;
- (void)clearSavedData;

@end
