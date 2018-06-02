#import "NSLayoutConstraintSpecHelper.h"

@implementation NSLayoutConstraintSpecHelper

+ (BOOL)isLayoutConstraint:(NSLayoutConstraint *)constraintOne
   equalToLayoutConstraint:(NSLayoutConstraint *)constraintTwo
{
    if (!constraintOne || !constraintTwo) {
        return NO;
    }
    
    BOOL hasEqualPriority = (constraintOne.priority == constraintTwo.priority);
    BOOL hasEqualFirstItem = (constraintOne.firstItem == constraintTwo.firstItem);
    BOOL hasEqualFirstAttribute = (constraintOne.firstAttribute == constraintTwo.firstAttribute);
    BOOL hasEqualRelation = (constraintOne.relation == constraintTwo.relation);
    BOOL hasEqualSecondItem = (constraintOne.secondItem == constraintTwo.secondItem);
    BOOL hasEqualSecondAttribute = (constraintOne.secondAttribute == constraintTwo.secondAttribute);
    BOOL hasEqualMultiplier = (constraintOne.multiplier == constraintTwo.multiplier);
    BOOL hasEqualConstant = (constraintOne.constant == constraintTwo.constant);
    BOOL hasEqualShouldBeArchived = (constraintOne.shouldBeArchived == constraintTwo.shouldBeArchived);
    
    return hasEqualPriority && hasEqualFirstItem && hasEqualFirstAttribute && hasEqualRelation &&
    hasEqualSecondItem && hasEqualSecondAttribute && hasEqualMultiplier && hasEqualConstant &&
    hasEqualShouldBeArchived;
}

@end
