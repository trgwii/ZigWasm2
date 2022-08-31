import {
  getControls,
  getScreen,
  screenHeight,
  screenWidth,
  updateAndRender,
} from "./wasm.js";

const ctl = getControls();

const up = 0;
const left = 2;
const down = 4;
const right = 6;
const pressed = 0;
const changed = 1;

addEventListener("keydown", (e) => {
  const k = e.key.toLowerCase();
  const key = (k === "arrowup" || k === "w")
    ? up
    : (k === "arrowleft" || k === "a")
    ? left
    : (k === "arrowdown" || k === "s")
    ? down
    : (k === "arrowright" || k === "d")
    ? right
    : -1;
  if (key === -1) return;
  ctl[key + changed] = Number(ctl[key + pressed] === 0);
  ctl[key + pressed] = 1;
});
addEventListener("keyup", (e) => {
  const k = e.key.toLowerCase();
  const key = (k === "arrowup" || k === "w")
    ? up
    : (k === "arrowleft" || k === "a")
    ? left
    : (k === "arrowdown" || k === "s")
    ? down
    : (k === "arrowright" || k === "d")
    ? right
    : -1;
  if (key === -1) return;
  ctl[key + changed] = Number(ctl[key + pressed] === 1);
  ctl[key + pressed] = 0;
});

const canvas = document.querySelector("canvas")!;
const offscreen = document.createElement("canvas");
const img = new ImageData(getScreen(), screenWidth(), screenHeight());
offscreen.width = img.width;
offscreen.height = img.height;
const ctx = offscreen.getContext("2d")!;
const drawCtx = canvas.getContext("2d")!;
offscreen.style.imageRendering = "pixelated";
canvas.style.imageRendering = "pixelated";
ctx.imageSmoothingEnabled = false;
drawCtx.imageSmoothingEnabled = false;
canvas.width = innerWidth;
canvas.height = innerHeight;
const scale = Math.min(innerWidth / img.width, innerHeight / img.height);
drawCtx.scale(scale, scale);
addEventListener("resize", () => {
  canvas.width = innerWidth;
  canvas.height = innerHeight;
  const scale = Math.min(innerWidth / img.width, innerHeight / img.height);
  drawCtx.scale(scale, scale);
});

document.body.style.margin = "0px";
document.body.style.overflow = "hidden";

let time = performance.now();
const loop = () => {
  let next = performance.now();
  const delta = (next - time) / 1000;
  time = next;
  updateAndRender(delta);
  const zig = performance.now() - next;
  ctx.putImageData(img, 0, 0);

  ctx.font = "12px monospace";
  ctx.fillText(
    `zig: ${zig}, ${delta}spf, ${Math.round(1 / delta)}fps`,
    5,
    10,
  );
  drawCtx.drawImage(offscreen, 0, 0);
  requestAnimationFrame(loop);
};
loop();
