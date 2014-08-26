#import "JustAViewController.h"
#import "InstagramSimpleOAuthViewController.h"
#import "InstagramLoginResponse.h"

@implementation JustAViewController

#pragma mark - IBActions

- (IBAction)pushInstagramVCOnNavStackTapped:(id)sender
{
    InstagramSimpleOAuthViewController
    *viewController = [[InstagramSimpleOAuthViewController alloc] initWithClientID:@"d34a41b0195f4f50b829a278b9b534ee"
                                                                      clientSecret:@"eb0f48287350402f862cf3a9b6e4aa1b"
                                                                       callbackURL:[NSURL URLWithString:@"http://honeypot.xyz"]
                                                                        completion:^(InstagramLoginResponse *response, NSError *error) {
                                                                            if (response.authToken) {
                                                                                [self displayToken:response.authToken];
                                                                            }
                                                                        }];
    
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

#pragma mark - Private Method

- (void)displayToken:(NSString *)authToken
{
    UIAlertView *tokenAlert = [[UIAlertView alloc] initWithTitle:@"Instagram Token"
                                                         message:[NSString stringWithFormat:@"Your Token is: %@", authToken]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    [tokenAlert show];
}

@end
