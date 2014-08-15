#import "JustAViewController.h"
#import "InstagramSimpleOAuthViewController.h"


@implementation JustAViewController

- (IBAction)pushInstagramVCOnNavStackTapped:(id)sender
{
    InstagramSimpleOAuthViewController
    *viewController = [[InstagramSimpleOAuthViewController alloc] initWithClientID:@"d34a41b0195f4f50b829a278b9b534ee"
                                                                      clientSecret:@"eb0f48287350402f862cf3a9b6e4aa1b"
                                                                       callbackURL:[NSURL URLWithString:@"http://honeypot.xyz"]
                                                                        completion:^(NSString *authToken) {
                                                                            NSLog(@"================> Token From Instagram: %@", authToken);
                                                                        }];
    
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

@end
