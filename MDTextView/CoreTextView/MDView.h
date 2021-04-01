#import <UIKit/UIKit.h>
@class MDViewFrameRef;
@class MDView;

@protocol MDViewDelegate <NSObject>

@optional
- (void)mdView:(MDView *)view didClickHyperlinks:(NSString *)url;

@end

@interface MDView : UIView

@property (nonatomic, weak) id<MDViewDelegate> delegate;
@property (nonatomic, strong) MDViewFrameRef *frameRef;

@end
