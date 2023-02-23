module mell.geometry.convex_shape;

import std.math;
import std.range;
import std.typecons;
import bindbc.sdl;

class ConvexShape {
    private SDL_Point[] points;
    private SDL_Color color;
    private bool fill;
    private bool outline;

    this(SDL_Point[] points, SDL_Color color, bool fill, bool outline) {
        this.points = points;
        this.color = color;
        this.fill = fill;
        this.outline = outline;
    }

    void draw(SDL_Renderer* renderer) {
        if (points.length < 3) {
            return; // Cannot draw a shape with less than 3 points
        }

        if (fill) {
            SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
            //SDL_RenderFillPolygon(renderer, points.ptr, cast(int) points.length);
        }

        if (outline) {
            SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a);
            SDL_RenderDrawLines(renderer, points.ptr, cast(int) points.length);
        }
    }

    void setFill(bool fill) {
        this.fill = fill;
    }

    void setOutline(bool outline) {
        this.outline = outline;
    }

    void setColor(SDL_Color color) {
        this.color = color;
    }
}