export const useGameControls = () => {
  const { move } = useGameLogic();

  let touchStartX = 0;
  let touchStartY = 0;

  function handleKeydown(e: KeyboardEvent) {
    const keyMap: Record<string, "up" | "down" | "left" | "right"> = {
      ArrowUp: "up",
      ArrowDown: "down",
      ArrowLeft: "left",
      ArrowRight: "right",
      w: "up",
      W: "up",
      s: "down",
      S: "down",
      a: "left",
      A: "left",
      d: "right",
      D: "right",
    };

    const direction = keyMap[e.key];
    if (direction) {
      e.preventDefault();
      move(direction);
    }
  }

  function handleTouchStart(e: TouchEvent) {
    const touch = e.touches[0];
    if (touch) {
      touchStartX = touch.clientX;
      touchStartY = touch.clientY;
    }
  }

  function handleTouchEnd(e: TouchEvent) {
    const touch = e.changedTouches[0];
    if (!touch) return;

    const dx = touch.clientX - touchStartX;
    const dy = touch.clientY - touchStartY;
    const threshold = 50;

    if (Math.abs(dx) > Math.abs(dy) && Math.abs(dx) > threshold) {
      move(dx > 0 ? "right" : "left");
    } else if (Math.abs(dy) > threshold) {
      move(dy > 0 ? "down" : "up");
    }
  }

  function initControls() {
    window.addEventListener("keydown", handleKeydown);
  }

  function destroyControls() {
    window.removeEventListener("keydown", handleKeydown);
  }

  return {
    handleTouchStart,
    handleTouchEnd,
    initControls,
    destroyControls,
  };
};
