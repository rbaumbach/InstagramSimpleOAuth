#import "TokenAlertControllerBuilder.h"

@implementation TokenAlertControllerBuilder

+ (UIAlertController *)buildUsingToken:(NSString *)token
{
    UIAlertController *tokenAlertController = [UIAlertController alertControllerWithTitle:@"Instagram Token"
                                                                                  message:[NSString stringWithFormat:@"Your Token is: %@", token]
                                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [tokenAlertController addAction:okAction];

    return tokenAlertController;
}

@end
