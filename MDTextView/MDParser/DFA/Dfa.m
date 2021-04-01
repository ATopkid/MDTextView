#import "Dfa.h"
#import "Node.h"

@implementation Dfa

#pragma mark -- <NSCopying>
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.end = [NSMutableSet set];
        self.alphabet = [NSMutableSet set];
        self.stateNodes = [NSMutableSet set];
    }
    return self;
}


@end
