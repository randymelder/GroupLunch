//
//  GroupLunchViewController.h
//  GroupLunch
//
//  Created by Randy Melder on 11/16/10.
//  Copyright SPiN Internet Media llc 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface GroupLunchViewController : UIViewController 
    <UITextFieldDelegate>
{
    UITextField  *uiTextViewBill;
    UITextField  *uiTextViewQtyPayers;
    UISlider    *uiSliderTip;
    UILabel     *uiLabelTip;
    UILabel     *uiLabelTipTotal;
    UILabel     *uiLabelPreTip;
    UILabel     *uiLabelWithTip;
    UILabel     *uiLabelTotalBill;
    UIImageView *uiImageBGImage;

}

@property (nonatomic, retain) IBOutlet UITextField  *uiTextViewBill;
@property (nonatomic, retain) IBOutlet UITextField  *uiTextViewQtyPayers;
@property (nonatomic, retain) IBOutlet UISlider     *uiSliderTip;
@property (nonatomic, retain) IBOutlet UILabel      *uiLabelTip;
@property (nonatomic, retain) IBOutlet UILabel      *uiLabelTipTotal;
@property (nonatomic, retain) IBOutlet UILabel      *uiLabelPreTip;
@property (nonatomic, retain) IBOutlet UILabel      *uiLabelWithTip;
@property (nonatomic, retain) IBOutlet UILabel      *uiLabelTotalBill;
@property (nonatomic, retain) IBOutlet UIImageView  *uiImageBGImage;

- (IBAction) doCalculations;
- (IBAction) showAboutView;

@end

