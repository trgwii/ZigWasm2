export const init = async (path: string) => {
  const response = fetch(path);

  const wasm = await WebAssembly.instantiateStreaming(response, {
    env: {
      __linear_memory: new WebAssembly.Memory({ initial: 0 }),
      __stack_pointer: new WebAssembly.Global({ value: "i32", mutable: true }),
      _print: (ptr: number, len: number) => {
        const arr = new Uint8ClampedArray(memory.buffer, ptr, len);
        const str = new TextDecoder().decode(arr);
        console.log(str);
      },
    },
  });

  const { exports } = wasm.instance;

  const memory = exports.memory as WebAssembly.Memory;

  const _getControls = exports.getControls as () => number;
  const sizeOfControls = exports.sizeOfControls as () => number;

  const getControls = () =>
    new Uint8ClampedArray(memory.buffer, _getControls(), sizeOfControls());

  const _getScreen = exports.getScreen as () => number;
  const sizeOfScreen = exports.sizeOfScreen as () => number;

  const getScreen = () =>
    new Uint8ClampedArray(memory.buffer, _getScreen(), sizeOfScreen());

  const screenWidth = exports.screenWidth as () => number;
  const screenHeight = exports.screenHeight as () => number;

  const updateAndRender = exports.updateAndRender as (
    delta: number,
  ) => void;

  return {
    memory,
    getControls,
    getScreen,
    screenWidth,
    screenHeight,
    updateAndRender,
  };
};
