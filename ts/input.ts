export const handle = (ctl: Uint8ClampedArray) => {
  const up = 0;
  const left = 2;
  const down = 4;
  const right = 6;
  const space = 8;
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
      : (k === " ")
      ? space
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
      : (k === " ")
      ? space
      : -1;
    if (key === -1) return;
    ctl[key + changed] = Number(ctl[key + pressed] === 1);
    ctl[key + pressed] = 0;
  });
};
