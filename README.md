# LoraExplorer
LoraExplorer is a simple Mac Application for showing LORA metadata

I am just publishing the source code, not the Xcode project, because it’s difficult to strip out account details, etc.

But since this is a minimal project it should be easy to get setup

Just start with a Xcode  swiftui project . if prompted, use swift data since future versions may take advantage of it

Copy all of the swift files into the project, you can either replace LoraExplorerApp or merge with your App class (if you use a different name)

The only package used is Swiftyjson
To install , File menu -> Add Package dependencies and then url https://github.com/SwiftyJSON/SwiftyJSON

About the code architecture 
This a Keep It Simple Sam ( KISS ) architecture, it would not be appropriate for something large or multi window - but for a utility it works fine.

The center is the global let pathsToScan = SafeArray()
When you drag a file into the main window, .onDrop(of: ["public.file-url"], isTargeted: nil) will push the file onto pathsToScan
There is a global timer timerPollStack which will go off every second
.onReceive(timerPollStack,..  will receive the timer event and call timerStuff()
timerStuff will make sure its only working on one file a time, pop a file, read the metadata and then update the details

That’s about it, its a very simple design 

If you want you can add your own Icon, in assets you will want to add AppIcon1024 and setup AppIcon with all the various sizes


Future 
 There are some features I might add if I ever find the time
1. Store the data in swift data
2. List the lora by type, SD SDXL, PONY , FLUX, etc.  maybe event some file management so it can move into directories
3. Query capability to show LORA where a term is somewhere in the Lora title, tags, keywords , etc.
4. Extract triggers
5. Have user input, like ranking the lora from 1 to 5 stars, add categories ( cyberpunk, fantasy, realism…. )

But for now I’m busy with my App , www.gadzoinks.com

