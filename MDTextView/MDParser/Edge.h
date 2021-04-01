#import <Foundation/Foundation.h>

@class Node;

@interface Edge : NSObject

@property (nonatomic, strong) NSString *ch;
@property (nonatomic, strong) Node *endNode;

- (instancetype)initWithEndNode:(Node *)node;

@end
