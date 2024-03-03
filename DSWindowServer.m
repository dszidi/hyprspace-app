#import "DSWindowServer.h"

/*
The general approach here is to communicate with the hyprspace plugin using C++.
Expose as much controls as possible in the hyprland plugin header file and call them from here.
*/

@implementation DSWindowServer: NSObject
- (void)connectToServer {
    // Connects to Hyprland plugin
    // Call your C++ function here eg.
    //PLUGIN_INIT(handle);
    NSLog(@"Connected to Hyprland plugin");
}

@end