#import "Edge.h"
#import "Node.h"

@implementation Edge

- (instancetype)initWithEndNode:(Node *)node {
    self = [super init];
    if (self) {
        self.endNode = node;
    }
    return self;
}

@end
