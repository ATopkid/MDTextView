#import "MDCtFrameToken.h"

@implementation MDCtFrameToken

- (instancetype)initWithType:(MDCtFrameTokenType)type {
    self = [super init];
    if (self) {
        self.type = type;
    }
    return self;
}
@end
