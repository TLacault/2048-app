import { describe, it, expect } from "vitest";
import { mount } from "@vue/test-utils";
import Tile from "~/components/game/Tile.vue";

describe("Tile Component", () => {
  it("renders tile with value 2 with correct background color", () => {
    const wrapper = mount(Tile, {
      props: {
        value: 2,
      },
    });

    // Vérifier que le composant affiche la valeur 2
    expect(wrapper.text()).toBe("2");

    // Vérifier que le composant a la classe CSS pour le fond orange (amber-100)
    expect(wrapper.classes()).toContain("bg-amber-100");
  });

  it("renders tile with value 4 with correct background color", () => {
    const wrapper = mount(Tile, {
      props: {
        value: 4,
      },
    });

    // Vérifier que le composant affiche la valeur 4
    expect(wrapper.text()).toBe("4");

    // Vérifier que le composant a la classe CSS pour le fond amber-200
    expect(wrapper.classes()).toContain("bg-amber-200");
  });

  it("renders empty tile (value 0) without displaying text", () => {
    const wrapper = mount(Tile, {
      props: {
        value: 0,
      },
    });

    // Vérifier que le composant n'affiche pas de texte pour une tuile vide
    expect(wrapper.text()).toBe("");

    // Vérifier que le composant a la classe pour une tuile vide
    expect(wrapper.classes()).toContain("bg-gray-300");
  });

  it("renders tile with value 2048 with correct styling", () => {
    const wrapper = mount(Tile, {
      props: {
        value: 2048,
      },
    });

    // Vérifier que le composant affiche la valeur 2048
    expect(wrapper.text()).toBe("2048");

    // Vérifier que le composant a les bonnes classes CSS
    expect(wrapper.classes()).toContain("bg-yellow-500");
    expect(wrapper.classes()).toContain("text-white");
  });
});
