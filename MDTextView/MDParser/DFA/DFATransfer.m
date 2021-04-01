#import "DFATransfer.h"

@implementation DFATransfer

- (instancetype)initWithStart:(NSMutableSet<Node *> *)start end:(NSMutableSet<Node *> *)end ch:(NSString *)ch {
    self = [super init];
    if (self) {
        self.start = start;
        self.end = end;
        self.ch = ch;
    }
    
    return self;
}
@end
