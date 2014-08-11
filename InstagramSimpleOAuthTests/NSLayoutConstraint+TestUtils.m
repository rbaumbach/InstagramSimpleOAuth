#import "NSLayoutConstraint+TestUtils.h"


@implementation NSLayoutConstraint (TestUtils)

- (BOOL)isEqualToNSLayoutConstraint:(NSLayoutConstraint *)layoutConstraint
{
    if (!layoutConstraint) {
        return NO;
    }
    
    BOOL hasEqualPriority = (self.priority == layoutConstraint.priority);
    BOOL hasEqualFirstItem = (self.firstItem == layoutConstraint.firstItem);
    BOOL hasEqualFirstAttribute = (self.firstAttribute == layoutConstraint.firstAttribute);
    BOOL hasEqualRelation = (self.relation == layoutConstraint.relation);
    BOOL hasEqualSecondItem = (self.secondItem == layoutConstraint.secondItem);
    BOOL hasEqualSecondAttribute = (self.secondAttribute == layoutConstraint.secondAttribute);
    BOOL hasEqualMultiplier = (self.multiplier == layoutConstraint.multiplier);
    BOOL hasEqualConstant = (self.constant == layoutConstraint.constant);
    BOOL hasEqualShouldBeArchived = (self.shouldBeArchived == layoutConstraint.shouldBeArchived);
    
    return hasEqualPriority && hasEqualFirstItem && hasEqualFirstAttribute && hasEqualRelation &&
        hasEqualSecondItem && hasEqualSecondAttribute && hasEqualMultiplier && hasEqualConstant &&
        hasEqualShouldBeArchived;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[NSLayoutConstraint class]]) {
        return NO;
    }
    
    return [self isEqualToNSLayoutConstraint:(NSLayoutConstraint *)object];
}

- (NSUInteger)hash
{
    return (int)self.priority ^ [self.firstItem hash] ^ self.firstAttribute ^ self.relation ^ [self.secondItem hash] ^
        self.secondAttribute ^ (int)self.multiplier ^ (int)self.constant ^ self.shouldBeArchived;
}

@end
