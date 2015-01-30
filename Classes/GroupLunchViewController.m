//
//  GroupLunchViewController.m
//  GroupLunch
//
//  Created by Randy Melder on 11/16/10.
//  Copyright SPiN Internet Media llc 2010. All rights reserved.
//

#import "GroupLunchViewController.h"
#import "AboutViewController.h"

#define DEBUG_ON NO

@implementation GroupLunchViewController

@synthesize uiTextViewBill;
@synthesize uiTextViewQtyPayers;
@synthesize uiSliderTip;
@synthesize uiLabelTip;
@synthesize uiLabelTipTotal;
@synthesize uiLabelPreTip;
@synthesize uiLabelWithTip;
@synthesize uiLabelTotalBill;
@synthesize uiImageBGImage;

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if ( [textField isEqual:uiTextViewBill] ) {
        uiTextViewBill.text         = @"";
    }
    else if ( [textField isEqual:uiTextViewQtyPayers] ) {
        uiTextViewQtyPayers.text    = @"";
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if ( [textField.text isEqual:@""] ) {
        textField.text              = @"1";
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    switch ([allTouches count]) {
        case 1:
        {
            UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
            switch ([touch tapCount] ) {
                case 2:
                    [self showAboutView];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            NSLog(@"touchesBegan %d", [allTouches count]);
            break;
    }
}

- (IBAction) showAboutView
{
    AboutViewController *vc     = [[AboutViewController alloc]
                                   initWithNibName:@"AboutViewController" 
                                   bundle:nil];
    vc.delegate                 = self;
    vc.modalTransitionStyle     = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:vc animated:YES];
    [vc release];
}

- (IBAction) doCalculations
{
    float tipPct    = round((double)[uiSliderTip value]);
    float amount    = [uiTextViewBill.text floatValue];
    int payers      = [uiTextViewQtyPayers.text intValue];
    
    float tipTotal              = amount * (tipPct / 100);
    float amountPerPayerNoTip   = amount / (float) payers;
    float amountPerPayerWTip    = (amount + tipTotal) / (float) payers;
    
    if (DEBUG_ON) 
    {
        NSLog(@"uiTextViewQtyPayers.text: %@", uiTextViewQtyPayers.text);
        NSLog(@"int payers: %d", payers);
        NSLog(@"uiTextViewBill.text: %@", uiTextViewBill.text);
        NSLog(@"Tip pct: %3.2f",tipPct);
        NSLog(@"amount: %3.2f",amount);
        NSLog(@"TipTotal: %3.2f",tipTotal);
    }
    
    uiLabelTip.text         = [NSString stringWithFormat:@"%3.f%@", tipPct, @"%"];
    uiLabelTipTotal.text    = [NSString stringWithFormat:@"%3.2f", tipTotal];
    uiLabelPreTip.text      = [NSString stringWithFormat:@"%3.2f", amountPerPayerNoTip];
    uiLabelWithTip.text     = [NSString stringWithFormat:@"%3.2f", amountPerPayerWTip];
    uiLabelTotalBill.text   = [NSString stringWithFormat:@"%3.2f", (float)(amount + tipTotal)];
    uiTextViewBill.text     = [NSString stringWithFormat:@"%3.2f", (float)amount];
}

- (BOOL) textFieldShouldReturn: (UITextField *) textField 
{
    [textField resignFirstResponder];
    [self doCalculations];
    return YES;
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
/*
- (void)loadView {

}
*/

- (void)viewWillAppear:(BOOL)animated
{
    // add observer for the respective notifications (depending on the os version)
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardDidShow:) 
													 name:UIKeyboardDidShowNotification 
												   object:nil];		
	} else {
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(keyboardWillShow:) 
													 name:UIKeyboardWillShowNotification 
												   object:nil];
	}
    
    [super viewWillAppear:YES];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    uiSliderTip.minimumValue            = 0.00;
    uiSliderTip.maximumValue            = 50.00;
    uiTextViewBill.keyboardType         = UIKeyboardTypeNumberPad;
    uiTextViewBill.returnKeyType        = UIReturnKeyDone;
    uiTextViewQtyPayers.keyboardType    = UIKeyboardTypeNumberPad;
    uiTextViewQtyPayers.returnKeyType   = UIReturnKeyDone;
    uiTextViewBill.text                 = @"50.00";
    uiTextViewQtyPayers.text            = @"1";
    uiSliderTip.value                   = 0.00;
    uiLabelTip.text                     = @"";
    uiLabelTipTotal.text                = @"0.00";
    uiLabelPreTip.text                  = @"0.00";
    uiLabelWithTip.text                 = @"0.00";
    uiLabelTotalBill.text               = @"0.00";
    
    [super viewDidLoad];
}


/* * * * * * * * * * * * * * * * * * * * 
 *
 * Adding custom keyboard done button
 *
 */
- (void)addButtonToKeyboard {
	// create custom button
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame = CGRectMake(0, 163, 106, 53);
	doneButton.adjustsImageWhenHighlighted = NO;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0) {
		[doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
		[doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
	} else {        
		[doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
		[doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
	}
	[doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
	// locate keyboard view
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView* keyboard;
	for(int i=0; i<[tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard found, add the button
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
			if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
				[keyboard addSubview:doneButton];
		} else {
			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
				[keyboard addSubview:doneButton];
		}
	}
}


- (void)keyboardWillShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 3.2) {
		[self addButtonToKeyboard];
	}
    if (DEBUG_ON) {
        NSLog(@"keyboardWillShow\n");
    }
}

- (void)keyboardDidShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		[self addButtonToKeyboard];
    }
    if (DEBUG_ON) {
        NSLog(@"keyboardDidShow\n");
    }
}

- (void)doneButton:(id)sender {
	if (DEBUG_ON) {
            NSLog(@"doneButton");
    }
    
    [uiTextViewBill resignFirstResponder];
    [uiTextViewQtyPayers resignFirstResponder];
    [self doCalculations];
}

/* * * * * * * * * * * * */


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
