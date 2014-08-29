#import "InstagramUser.h"


NSString *const InstagramIDKey = @"id";
NSString *const InstagramUsernameKey = @"username";
NSString *const InstagramFullNameKey = @"full_name";
NSString *const InstagramProfilePictureKey = @"profile_picture";

@implementation InstagramUser

#pragma mark - Init Methods

- (instancetype)initWithDictionary:(NSDictionary *)userResponse
{
    self = [super init];
    if (self) {
        if (userResponse) {
            self.userID = userResponse[InstagramIDKey];
            self.username = userResponse[InstagramUsernameKey];
            self.fullName = userResponse[InstagramFullNameKey];
            self.profilePictureURL = [NSURL URLWithString:userResponse[InstagramProfilePictureKey]];
        }
    }
    return self;
}

- (instancetype)init
{
    return [self initWithDictionary:nil];
}
@end
