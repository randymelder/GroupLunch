//
//  BannerAdViewController.h
//  GroupLunch
//
//  Created by Randy Melder on 12/18/10.
//  Copyright 2010 spin internet media llc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


@interface BannerAdViewController : UIViewController <ADBannerViewDelegate> {
    ADBannerView *delegate;
}

@property (nonatomic,retain) IBOutlet ADBannerView *delegate;

@end
