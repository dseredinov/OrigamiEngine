//
//  OutputUnitTests.m
//  OrigamiEngine
//
//  Created by ap4y on 8/14/12.
//
//

#import "OutputUnitTests.h"

#import "ORGMConverter.h"
#import "ORGMInputUnit.h"
#import "ORGMOutputUnit.h"

@interface OutputUnitTests ()
@property (retain, nonatomic) ORGMOutputUnit* outputUnit;
@end

@implementation OutputUnitTests

- (void)setUp {
    [super setUp];
    ORGMInputUnit* input = [[ORGMInputUnit alloc] init];
    NSURL* flacUrl = [[NSBundle bundleForClass:self.class] URLForResource:@"multiple-vc"
                                                            withExtension:@"flac"];
    [input openWithUrl:flacUrl];
    ORGMConverter* converter = [[ORGMConverter alloc] initWithInputUnit:input];
        
    _outputUnit = [[ORGMOutputUnit alloc] initWithConverter:converter];
    [converter setupWithOutputUnit:_outputUnit];
    
    [input release];
    [converter release];
}

- (void)tearDown {
    [_outputUnit release];
    [super tearDown];
}

- (void)testOutputUnitShouldHaveValidFormat {
    AudioStreamBasicDescription format = [_outputUnit format];
    STAssertEquals((NSInteger)format.mChannelsPerFrame, 2, nil);
    STAssertEquals((NSInteger)format.mBytesPerFrame, 4, nil);
    STAssertEquals((NSInteger)format.mBytesPerPacket, 4, nil);
}

- (void)testOutputUnitShouldReturnAmountPlayed {
    STAssertEqualsWithAccuracy([_outputUnit amountPlayed], 0.0, 0.1, nil);
}

- (void)testOutputUnitShouldConvertFramesToSeconds {
    double seconds = [_outputUnit framesToSeconds:10000];
    STAssertEqualsWithAccuracy(seconds, 0.2267, 0.1, nil);
}

- (void)testOutputUnitShouldChangePlayedTimeAfterSeek {
    [_outputUnit seek:10.0];
    STAssertEqualsWithAccuracy([_outputUnit amountPlayed], 10.0, 0.1, nil);
}

@end
