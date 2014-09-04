

@interface UIAlertView (TestUtils)

+ (UIAlertView *)currentAlertView;
+ (void)reset;

- (void)dismissWithOkButton;
- (void)dismissWithCancelButton;

@end

// File taken from PivotaCoreKit
// https://github.com/pivotal/PivotalCoreKit