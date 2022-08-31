zig build-lib\
 --export=getControls\
 --export=sizeOfControls\
 --export=getScreen\
 --export=sizeOfScreen\
 --export=screenWidth\
 --export=screenHeight\
 --export=updateAndRender\
 -dynamic\
 -O ReleaseSafe\
 -target wasm32-freestanding\
 cpp/main.cpp\
 -femit-bin=public/wasm/CWasm2.wasm
