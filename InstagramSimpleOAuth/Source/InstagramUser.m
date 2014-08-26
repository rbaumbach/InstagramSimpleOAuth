#import "InstagramUser.h"


@implementation InstagramUser

#pragma mark - Init Methods

- (instancetype)initWithUserResponse:(NSDictionary *)userResponse
{
    self = [super init];
    if (self) {
        if (userResponse) {
            self.userID = userResponse[@"id"];
            self.username = userResponse[@"username"];
            self.fullName = userResponse[@"full_name"];
            self.profilePictureURL = [NSURL URLWithString:userResponse[@"profile_picture"]];
        }
    }
    return self;
}


- (instancetype)init
{
    return [self initWithUserResponse:nil];
}
@end
