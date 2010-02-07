#import "CBStringServiceCenter.h"

int main(int argc, char** argv) {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	CBStringServiceCenter* stringServiceCenter =
		[[CBStringServiceCenter alloc] initWithName: @"CBService:String"];
	NSLog(@"Serving: %d", [stringServiceCenter startServing]);
	[pool release];
	return 0;
}

