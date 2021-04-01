#import "Nfa.h"
#import "Node.h"

@implementation Nfa

#pragma mark -- <NSCopying>
- (id)copyWithZone:(nullable NSZone *)zone
{
    Nfa *copyNfa = [[[self class] allocWithZone:zone] init];
    
    copyNfa.alphabet = [self.alphabet copyWithZone:zone];
    copyNfa.stateNodes = [self.stateNodes copyWithZone:zone];
    copyNfa.end = [self.end copyWithZone:zone];
    copyNfa.start = [self.start copyWithZone:zone];
     
    return copyNfa;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.alphabet = [NSMutableSet set];
        self.stateNodes = [NSMutableSet set];
    }
    return self;
}
@end
