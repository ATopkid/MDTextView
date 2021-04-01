#import <Foundation/Foundation.h>

@class MDViewFrameRef;
@class MDCtFrameToken;
@class CTFrameParserConfig;

@interface MDCtFrameBuilder : NSObject

+ (MDViewFrameRef *)parseContent:(NSString *)string config:(CTFrameParserConfig *)config tokens:(NSArray<MDCtFrameToken *> *)tokens;

@end
