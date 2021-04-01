#import "Node.h"

static NSUInteger nodeId = 0;

@implementation Node

#pragma mark -- <NSCopying>
- (id)copyWithZone:(nullable NSZone *)zone
{
    Node *copyNode = [[[self class] allocWithZone:zone] init];
    
    copyNode.nodeId = self.nodeId;
    copyNode.edges = [self.edges copyWithZone:zone];
    
    return copyNode;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.edges = [NSMutableSet set];
        self.nodeId = nodeId++;
    }
    return self;
}

- (NSUInteger)hash {
    return self.nodeId;
}
@end
