#import <Foundation/Foundation.h>

@class Edge;

@interface Node : NSObject <NSCopying>

@property (nonatomic, assign) int nodeId;
@property (nonatomic, strong) NSMutableSet <Edge *> *edges;

@end
