#import "AppDelegate.h"
#import "InstagramSimpleOAuthViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    InstagramSimpleOAuthViewController *viewController = [[InstagramSimpleOAuthViewController alloc] initWithClientID:@""
                                                                                                         clientSecret:@""
                                                                                                          callbackURL:nil
                                                                                                           completion:nil];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
