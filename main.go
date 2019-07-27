package main

// #cgo CFLAGS: -g -Wall
// #include <stdlib.h>
// #include "api.h"
import "C"
import (
	"fmt"
	"unsafe"
)

var DATE string
var LATEST_COMMIT string
var BUILD_NUMBER string
var BUILT_ON_IP string
var BUILT_ON_OS string

type BuildInfo struct {
    DATE          string
    LATEST_COMMIT string
    BUILD_NUMBER  string
    BUILT_ON_IP   string
    BUILT_ON_OS   string
}

var AppBuildInfo *BuildInfo

func Banner(appName string) {

    fmt.Printf("Starting %v\n", appName)
    fmt.Println("(c)2018 Peerstream")
    fmt.Printf("\n")
    fmt.Printf("***********************************\n")
    fmt.Printf("*\n")
    fmt.Printf("* DATE         : %s\n", DATE)
    fmt.Printf("* LATEST_COMMIT: %s\n", LATEST_COMMIT)
    fmt.Printf("* BUILD_NUMBER : %s\n", BUILD_NUMBER)
    fmt.Printf("* BUILT_ON_IP  : %s\n", BUILT_ON_IP)
    fmt.Printf("* BUILT_ON_OS  : %s\n", BUILT_ON_OS)
    fmt.Printf("*\n")
    fmt.Printf("***********************************\n")
    fmt.Printf("\n")
}

func init() {
    AppBuildInfo = &BuildInfo{
        DATE:          DATE,
        LATEST_COMMIT: LATEST_COMMIT,
        BUILD_NUMBER:  BUILD_NUMBER,
        BUILT_ON_IP:   BUILT_ON_IP,
        BUILT_ON_OS:   BUILT_ON_OS,
    }
}


func main() {
    Banner("cgo-simple-example")

	buf := C.malloc(C.sizeof_char * 1024)
	defer C.free(unsafe.Pointer(buf))

	sz := C.helloFromC((*C.char)(buf))

	b := C.GoBytes(buf, sz)
	msg := string(b)

	fmt.Printf("Len: %d\n", sz)
	fmt.Printf("Msg: %s\n", msg)
}
