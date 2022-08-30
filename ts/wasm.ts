const response = fetch("/wasm/ZigWasm2.wasm");

const wasm = await WebAssembly.instantiateStreaming(response, {
  env: {
    __linear_memory: new WebAssembly.Memory({ initial: 0 }),
    __stack_pointer: new WebAssembly.Global({ value: "i32", mutable: true }),
  },
});

const { exports } = wasm.instance;

(globalThis as any).exports = exports;

export const memory = exports.memory as WebAssembly.Memory;

export const getControls = exports.getControls as () => number;
export const getScreen = exports.getScreen as () => number;
export const updateAndRender = exports.updateAndRender as (
  delta: number,
) => void;
