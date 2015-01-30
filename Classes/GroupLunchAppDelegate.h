//
//  GroupLunchAppDelegate.h
//  GroupLunch
//
//  Created by Randy Melder on 11/16/10.
//  Copyright SPiN Internet Media llc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupLunchViewController;

@interface GroupLunchAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GroupLunchViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GroupLunchViewController *viewController;

@end

