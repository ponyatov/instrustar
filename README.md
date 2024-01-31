# SDK
## The Sdk of Instrustar Series Oscilloscopes.
### The open source support for oscilloscopes

- ISDS205
- ISDS210
- ISDS220
- ISDS206

## Demo

### demo-VC
	
	a Demo written with VC
	
### demo-Labview
	
	a Demo written with Labview, only test in Windows

### demo-Python
	
	a Demo written with Python,only test in Windows

### DllTest
	
	a command line Demo written with C++, test in Windows and Ubuntu Linux

### DllTestQt

	a Demo written with Qt, test in Windows and Ubuntu Linux

	Note: To start Qt, please use `sudo`. This ensures that `libusb`
    can detect the device correctly
	
## Linux

### Debian 11

```sh
    sudo apt update
    sudo apt install -uy `cat apt.Debian11`
```

### libusb

1. install libusb

```sh
	tar xvjf libusb-1.0.24.tar.bz2
	./configure --build=x86_64-linux --disable-udev
	sudo make install
```

or in-system:

```sh
    sudo apt install -uy libusb-1.0-0-dev
```
```
libusb-1.0-0    :amd64   2:1.0.26-1
libusb-1.0-0-dev:amd64   2:1.0.26-1
```

2. copy `./linux/*.so` files

- to your system dynamic libraries like `/lib` or `/usr/lib`
- into directory with your binary executables (distribution package)
	
3. Compile dlltest and then run

```sh
	sudo ./DllTest
```
