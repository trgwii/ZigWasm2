const response = fetch("wasm/ZigWasm2.wasm");

const wasm = await WebAssembly.instantiateStreaming(response, {
  env: {
    __linear_memory: new WebAssembly.Memory({ initial: 0 }),
    __stack_pointer: new WebAssembly.Global({ value: "i32", mutable: true }),
  },
});

const { exports } = wasm.instance;

(globalThis as any).exports = exports;

export const memory = exports.memory as WebAssembly.Memory;

const _getControls = exports.getControls as () => number;
const sizeOfControls = exports.sizeOfControls as () => number;

export const getControls = () =>
  new Uint8ClampedArray(memory.buffer, _getControls(), sizeOfControls());

const _getScreen = exports.getScreen as () => number;
const sizeOfScreen = exports.sizeOfScreen as () => number;

export const getScreen = () =>
  new Uint8ClampedArray(memory.buffer, _getScreen(), sizeOfScreen());

export const screenWidth = exports.screenWidth as () => number;
export const screenHeight = exports.screenHeight as () => number;

export const updateAndRender = exports.updateAndRender as (
  delta: number,
) => void;
