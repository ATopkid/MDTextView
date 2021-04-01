#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <UIKit/UIKit.h>

@class MDCtFrameToken;

@interface MDViewFrameRef : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (strong, nonatomic) NSArray<MDCtFrameToken *> *hyperlinks;

@end
