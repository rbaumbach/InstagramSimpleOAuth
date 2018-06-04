#import <UIKit/UIKit.h>

@interface NSLayoutConstraintSpecHelper : NSObject

+ (BOOL)isLayoutConstraint:(NSLayoutConstraint *)constraintOne
   equalToLayoutConstraint:(NSLayoutConstraint *)constraintTwo;

@end
