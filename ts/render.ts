export const rendering = (
  screen: Uint8ClampedArray,
  width: number,
  height: number,
) => {
  const img = new ImageData(screen, width, height);
  const offscreen = Object.assign(document.createElement("canvas"), {
    width: img.width,
    height: img.height,
  });
  const ctx = offscreen.getContext("2d")!;
  const canvas = document.querySelector("canvas")!;
  const drawCtx = canvas.getContext("2d")!;
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
  return { img, offscreen, ctx, drawCtx };
};
