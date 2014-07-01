//
//  TFWordOfTheDayFetcher.m
//  WordOfTheDay
//
//  Created by LittleFin on 6/23/14.
//  Copyright (c) 2014 Michael Dattolo. All rights reserved.
//

#import "TFWordOfTheDayFetcher.h"
#import "XMLDictionary.h"

@interface TFWordOfTheDayFetcher ()


- (NSDate *)normalizedDate:(NSDate *)date;
- (void)saveWordOfTheDay:(TFWordOfTheDay *)word;

@end


@implementation TFWordOfTheDayFetcher

- (void)refreshWordOfTheDayForDate:(NSDate *)date withIdentifier:(NSString *)identifier {
    
    // Only try fetch a new word if we haven't already fetched today
    if (![self wordHasBeenFetchedForDate:date]) {
        NSLog(@"Should Refresh");
        
        NSURL *wordOfTheDayRSS = [NSURL URLWithString:@"https://wordsmith.org/awad/rss1.xml"];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session downloadTaskWithURL:wordOfTheDayRSS completionHandler:^(NSURL *location,
                                                                          NSURLResponse *response,
                                                                          NSError *error) {
            
            NSDictionary *dictionary = [NSDictionary dictionaryWithXMLFile:[location path]];
            NSLog(@"Downloaded New Word, %@", self.delegate);
            NSDictionary *wordOfTheDay = [[dictionary objectForKey:@"channel"] objectForKey:@"item"];
            
            TFWordOfTheDay *word = [TFWordOfTheDay new];
            
            word.word = [wordOfTheDay objectForKey:@"title"];
            word.definition = [wordOfTheDay objectForKey:@"description"];
            word.urlString = [wordOfTheDay objectForKey:@"link"];
            word.date = [NSDate date];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate newWordOfTheDayReceived:word];
            });
            
            // Comment this line to force refresh of data from web each time
            [self saveWordOfTheDay:word];
            
            
        } ] resume];
        
    }
}

- (void)clearSavedData {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.aTinyFish.WordOfTheDay"];
    [sharedDefaults setObject:@"squirrelly" forKey:@"TodaysWord"];
    [sharedDefaults setObject:@"Restless, jumpy, nervy." forKey:@"TodaysDefinition"];
    [sharedDefaults setObject:@"http://wordsmith.org/words/squirrelly.html" forKey:@"TodaysURL"];
    [sharedDefaults setObject:[NSDate distantPast] forKey:@"LastFetchDate"];
    [sharedDefaults synchronize];
    
}




- (BOOL)wordHasBeenFetchedForDate:(NSDate *)date {
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.aTinyFish.WordOfTheDay"];
    NSDate *lastFetchDate = [sharedDefaults objectForKey:@"LastFetchDate"];
    
    if (lastFetchDate) {
        if ([[self normalizedDate:date] isEqualToDate:[self normalizedDate:lastFetchDate]])
            return YES;
    }
    
    return NO;
}

- (NSDate *)normalizedDate:(NSDate *)aDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ) fromDate:aDate];
    
    return [calendar dateFromComponents:components];
}

- (void)saveWordOfTheDay:(TFWordOfTheDay *)word {
    
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.aTinyFish.WordOfTheDay"];
    
    [sharedDefaults setObject:word.word forKey:@"TodaysWord"];
    [sharedDefaults setObject:word.definition forKey:@"TodaysDefinition"];
    [sharedDefaults setObject:word.urlString forKey:@"TodaysURL"];
    [sharedDefaults setObject:[NSDate date] forKey:@"LastFetchDate"];
    
}


#pragma mark - NSURLSession Delegate
// This code is only necessary when using NSURLSession in the background

//- (NSURLSession *)configureSessionWithIdentifier:(NSString *)identifier {
//    
//    
//    static NSURLSession *session = nil;
//    static dispatch_once_t token;
//    
//    dispatch_once(&token, ^ {
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
//        configuration.sharedContainerIdentifier = @"group.aTinyFish.WordOfTheDay";
//        session = [NSURLSession sessionWithConfiguration:configuration delegate:self
//                                           delegateQueue:nil];
//    });
//    
//    return session;
//    
//}
//
//
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
//
//    NSDictionary *dictionary = [NSDictionary dictionaryWithXMLFile:[location path]];
//    NSLog(@"Downloaded New Word, %@", self.delegate);
//    NSDictionary *wordOfTheDay = [[dictionary objectForKey:@"channel"] objectForKey:@"item"];
//    
//    TFWordOfTheDay *word = [TFWordOfTheDay new];
//    
//    word.word = [wordOfTheDay objectForKey:@"title"];
//    word.definition = [wordOfTheDay objectForKey:@"description"];
//    word.urlString = [wordOfTheDay objectForKey:@"link"];
//    word.date = [NSDate date];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.delegate newWordOfTheDayReceived:word];
//    });
//    
//    // Comment this line to force refresh of data from web each time
//    [self saveWordOfTheDay:word];
//    
//}
//
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
//}
//
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
//}
//
//- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
//{
//    [self.delegate URLSessionDidFinishEventsForBackgroundURLSession:session];
//}


@end
