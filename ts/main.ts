import { init } from "./wasm.js";
import { handle } from "./input.js";
import { rendering } from "./render.js";

document.body.style.margin = "0px";
document.body.style.overflow = "hidden";

// const native = await init("wasm/ZigWasm2.wasm");
const native = await init("wasm/CWasm2.wasm");

handle(native.getControls());
const { ctx, drawCtx, img, offscreen } = rendering(
  native.getScreen(),
  native.screenWidth(),
  native.screenHeight(),
);

const { updateAndRender } = native;

let time = performance.now();
const loop = () => {
  let next = performance.now();
  const delta = (next - time) / 1000;
  time = next;
  updateAndRender(delta);
  const zig = performance.now() - next;
  ctx.putImageData(img, 0, 0);

  ctx.font = "12px monospace";
  ctx.fillStyle = "white";
  ctx.fillText(
    `c: ${zig}, ${delta}spf, ${Math.round(1 / delta)}fps`,
    5,
    10,
  );
  drawCtx.drawImage(offscreen, 0, 0);
  requestAnimationFrame(loop);
};
loop();
