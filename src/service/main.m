#import "CBStringService.h"

int main(int argc, char** argv) {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	CBStringService* stringService = [[CBStringService alloc] init];
	NSLog(@"Serving %@: %d", stringService.name, [stringService startServing]);
	[pool release];
	return 0;
}

