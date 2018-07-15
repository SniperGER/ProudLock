# ProudLock
Be proud of that lock

-----

ProudLock enables the Face ID latch glyph, internally called SBUIProudLockIconView, on older devices.  
This tweak it at first **source code only**, which means there is no .deb file you can download or install.

ProudLock is still in a very early state, and while it does work, there are a lot of layout issues, especially on 4.7" screens and smaller. Everything has to be moved dowm by 40px (the height of the latch glyph), and while I'm able to move down the clock (unfortunately with a fixed value that does work on my iPhone 6s, but I'm not sure about other devices), this doesn't apply to notification views at all.

I'm releasing ProudLock in this state so more experienced developers can have a look and contribute if they want.

### Known Issues
* Incomplete layout (clock, notifications)  
* Missing latch body on 4" and 4.7" screens

-----

### How to fix the missing latch body
Download [this file](https://github.com/MDausch/LatchKey/blob/master/Layout/Library/Application%20Support/LatchKey/Themes/Apple_Default.bundle/Apple_Default.ca/assets/lockBaseFINAL%403x.png) (lockBaseFinal@3x.png) from LatchKey. This is the extracted latch body from Assets.car inside SpringBoardUIServices.framework. Copy this file to your device however you want and move it to the following path: 
`/System/Library/PrivateFrameworks/SpringBoardUIServices.framework/biglock.ca/assets`  
Rename the file to `lockBaseFINAL@2x`. Note the **@2x**.

Now open `main.caml` in the folder above and look for `<contents type="CGImage" src="assets/lockBaseFINAL@3x"/>`. Rename it to `lockBaseFINAL@2x`, too.

If you restart SpringBoard now, it *should* appear if you have enabled a passcode. The latch glyph however only works if you use Touch ID.