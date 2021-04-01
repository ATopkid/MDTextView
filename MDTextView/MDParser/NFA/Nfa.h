#import <Foundation/Foundation.h>

@class Node;
@interface Nfa : NSObject<NSCopying>

@property (nonatomic, strong) NSMutableSet<NSString *> *alphabet;
@property (nonatomic, strong) Node *start;
@property (nonatomic, strong) NSMutableSet<Node *> *stateNodes;
@property (nonatomic, strong) Node *end;

@end
