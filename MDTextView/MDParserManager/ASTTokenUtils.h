#import <Foundation/Foundation.h>

@class MDCtFrameTokenHyperlinks;
@class ASTNode;

@interface ASTTokenUtils : NSObject

+ (MDCtFrameTokenHyperlinks *)frameTokenWithNode:(ASTNode *)root;

@end


