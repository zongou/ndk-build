# Build Busybox for android

| Variable                             | Meaning                  |
| ------------------------------------ | ------------------------ |
| CC="${CC}"                           | target platform compiler |
| HOSTCC=gcc                           | build platform compiler  |
| CROSS_COMPILER="aarch64-linux-musl-" | cross compiler prefix    |

## Configure

```sh
make <...> menuconfig

# cli
make config
```

### Minimal adjustion to build

- Settings
  - [ ] Support utmp file
  - [ ] Support writing pidfiles
  - [ ] Drop SUID state for most applets
- Coreutils
  - [ ] hostid
  - [ ] logname @v1.36
  - [ ] sync @v1.36
- Console Utils
  - [ ] loadfont
  - [ ] setfont
- Login/Password Management Utils
  - [ ] su
- Linux System Utils
  - [ ] fsck.minix
  - [ ] ipcrm
  - [ ] ipcs
  - [ ] mkfs.minix
  - [ ] swapon
  - [ ] swapoff
- Miscellanrous Utils
  - [ ] adjtimex @v1.36.1
  - [ ] conspy
  - [ ] seedrng @v1.36
- Network Utils
  - [ ] Enable IPv6 support
  - [ ] ether-wake
  - [ ] nslookup
- Shells
  - [ ] hush
  - [ ] Internal shell for embedded script support @v1.36
- System Logging Utils
  - [ ] (all)

## Optimized adjustion

- Settings

  - [x] Tab completion.
  - [x] Username completion
  - [x] Fancy shell prompts
  - (0) Range of supported Unicode characters
  - [x] Allow wide Unicode characters on output

- Arhives Utilities:

  - [x] Enable compression levels
  - [x] Optimise lzma for speed

- Coreutils

- Console Utils

- Editors:

  - [x] Allow to display 8-bit chars (otherwise show dots)

- Login/Password Management Utils

- Linux System Utils

- Miscellanrous Utils

- Network Utils

- Shells

- System Logging Utils

## Build

```sh
make <...> busybox_unstripped
```

## Install

busybox image install to dir

```sh
make <...> install CONFIG_PREFIX="${OUTPUT_DIR}"
```

## Examples

- <https://github.com/termux/termux-packages/blob/master/packages/busybox/build.sh>
- <https://github.com/rsepassi/simplelinux/blob/main/busybox/build.sh>
