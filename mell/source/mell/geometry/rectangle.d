module mell.geometry.rectangle;

import std.math;
import std.typecons;
import bindbc.sdl;

class Rectangle {
    private int x;
    private int y;
    private int width;
    private int height;
    private SDL_Color fillColor;
    private SDL_Color outlineColor;
    private int outlineThickness;

    this(int x, int y, int width, int height, SDL_Color fillColor, SDL_Color outlineColor, int outlineThickness) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.fillColor = fillColor;
        this.outlineColor = outlineColor;
        this.outlineThickness = outlineThickness;
    }

    void draw(SDL_Renderer* renderer) {
        SDL_Rect rect = SDL_Rect(x, y, width, height);

        if (outlineThickness > 0) {
            SDL_SetRenderDrawColor(renderer, outlineColor.r, outlineColor.g, outlineColor.b, outlineColor.a);
            SDL_RenderDrawRect(renderer, &rect);
        }

        if (fillColor.a > 0) {
            SDL_SetRenderDrawColor(renderer, fillColor.r, fillColor.g, fillColor.b, fillColor.a);
            SDL_RenderFillRect(renderer, &rect);
        }
    }
}
