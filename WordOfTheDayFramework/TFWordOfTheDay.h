//
//  TFWordOfTheDay.h
//  WordOfTheDay
//
//  Created by LittleFin on 6/23/14.
//  Copyright (c) 2014 Michael Dattolo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TFWordOfTheDay : NSObject

@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSString *definition;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *urlString;

@end
