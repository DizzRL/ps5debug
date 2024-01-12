# PS5Debug

## Warning
The code is probably a mess, sorry... also I suck at documentation so you get what you get lol

## Info

This has some slight API changes from ps4debug, but not a lot, and most things should still function like normal.

Because of the lack of time to work on things, ill be open sourcing this un-finished, and would love community contributions

Right now this is built using the ps5-payload-sdk, and will build as an elf that needs to be loaded through an elf loader... will probably change that eventually so it can run standalone if a user wants (untested on HEN-V)

## Unfinished Items
- Debugger has a lot of issues, it needs finished
- `proc_scan_compareValues` needs done
- `proc_scan_getSizeOfValueType` needs done
- `proc_scan_handle` needs done

## New Commands
- Unload
    ```
    Command to kill the payload
    Command: 0xBD0000FF
    No payload packet needed
    ```
- Process Base
    - Command to return the base address for a process
    - Command: 0xBDAA000D
        ```
        struct cmd_proc_base_packet {
            uint32_t pid;
        } __attribute__((packed));
        #define CMD_PROC_BASE_PACKET_SIZE 4
        ```

## Current Tested Features
 - Console Commands
    - Reboot
    - Print
    - Notify
    - Unload (New)
    - Version
- Kernel Commands
    - Kernel Base
    - Read Memory
    - Write Memory
- Process Commands
    - Process Base (New)
    - Process List
    - Read Memory
    - Write Memory
    - VM Maps
    - Allocate (r/w only by default)
    - Protect (ignores length, and sets a protection level of 0x7 to the entire map in the vm_entry)
    - InstallRPC (this is faked right now, as its not actually needed, it will return a bogus address)
    - Call (Takes a rpcstub but ignores it, as it uses ptrace to do calls now)
    - Free (idk if this actually does anyting?)
    - Info
    - Load Elf (needs to be updated, using a ptrace elfloader that kind of soft locks the game sometimes)
- Debugger
    - I think most of its broken right now lol, someone that knows more about ptrace and debuggers than me could probably fix it pretty quick, its mostly a copy paste of the ps4 code right now

## Changes Required
- The elf loader needs to be re made, and more specific to loading an elf into a game, it has a slightly modified version now, but I think more needs to be done
- Maybe find an alternative to the free method? (idk if it even does anything right now)
- Maybe find an alternative to the protect method? (so we can protect certain addresses, and not the entire vm_entry)
- We don't need to use `sceNetSocket` functions, should probably move awy from that, but for now it was easier to replicate with it

## How to build
Follow the instructions for the [ps5-payload-sdk](https://github.com/john-tornblom/ps5-payload-sdk)
I believe the only additional library needed is `libSceNet.sprx`
The just run `make`

# Credits
This is a really important section, this project would not have been doable without the foundation work of a lot of really smart people.
- Big credit to [astrelsky](https://github.com/astrelsky) with all his work on HEN-V and for process read / write code, as well as many other things
- Big credit to [John Tornblom](https://github.com/john-tornblom) for his ps5-payload-sdk, as well as the sample elf loader I am using
- Credit to SiSTRo for the idea on how to set a protection level
- And of course, credit to golden for the original ps4debug... where most of this code was grabbed from.
