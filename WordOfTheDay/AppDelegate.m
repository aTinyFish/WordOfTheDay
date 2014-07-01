//
//  AppDelegate.m
//  WordOfTheDay
//
//  Created by LittleFin on 6/23/14.
//  Copyright (c) 2014 Michael Dattolo. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
            

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.viewController = (ViewController *)self.window.rootViewController;
    [self setDefaults];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

    [self.viewController refresh];
    return YES;
    
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


@end
