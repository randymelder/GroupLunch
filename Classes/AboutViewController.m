//
//  AboutViewController.m
//  GroupLunch
//
//  Created by Randy Melder on 11/24/10.
//  Copyright 2010 SPiN Internet Media llc. All rights reserved.
//

#import "AboutViewController.h"

#define DEBUG_ON NO

@implementation AboutViewController

@synthesize uiWebViewAbout;
@synthesize delegate;

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSSet *allTouches = [event allTouches];
    switch ([allTouches count]) {
        case 1:
        {
            UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
            switch ([touch tapCount] ) {
                case 2:
                    [delegate dismissModalViewControllerAnimated:YES];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            
            break;
    }
}



/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *sHTML = [[NSString alloc] initWithFormat:@"<h1 align=\"center\" "
                       "style=\"margin-top: 24px; font-family:courier; "
                       "font-size:12px;\">Credits</h1>"
                       "<p align=\"center\" style=\"font-family:courier; "
                       "font-size:12px;\">Author<br />"
                       "<strong>Randy Melder</strong><br />"
                       "randymelder.com"
                       "<br /><br />"
                       "Graphic Design<br />"
                       "<strong>Dan Traynor</strong><br />"
                       "danieltraynor.com<br /><br />"
                       "Copyright (c) 2010<br /> SPiN Internet Media llc"
                       "</p>"];
    [uiWebViewAbout loadHTMLString:sHTML baseURL:[NSURL URLWithString:@"http://www.hitchhiker.com/message"]];
    [sHTML release];
                       
}



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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
