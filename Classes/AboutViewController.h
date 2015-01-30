//
//  AboutViewController.h
//  GroupLunch
//
//  @version 1.1 
//  - Changed behavior so when the user begins edting a text field, it clears.
//  - Made app ios 4.0 compatible.
//  - Added spin logo to about page.
//  - Fixed user input bug creating a nan when fields left empty for calculations.
//  - Added iAd banner
//  - Fixed splash screen image which was never really visible anyway...
//
//  Created by Randy Melder on 11/24/10.
//  Copyright 2010 SPiN Internet Media llc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface AboutViewController : UIViewController {
    UIWebView *uiWebViewAbout;
    UIViewController    *delegate;

}

@property (nonatomic, retain) IBOutlet UIWebView *uiWebViewAbout;
@property (nonatomic, assign) UIViewController  *delegate;

@end
