module editor.nodes.begin_node;

import editor.drawable_node;
import mell.geometry.rectangle;
import bindbc.sdl;

class BeginDrawableNode : DrawableNode {

    private Rectangle backgroundRect;
    private Rectangle topRect;

    this(int x, int y) {
        this.x = x;
        this.y = y;
        this.width = 100;
        this.height = 100;
        auto fillColor = SDL_Color(255, 123, 83, 255);
        auto outlineColor = SDL_Color(100, 10, 83, 255);
        auto outlineWidth = 1;
        backgroundRect = new Rectangle(x, y, width, height, fillColor, outlineColor, outlineWidth);
    } 

    public override void update() {
        
    }

    public override void draw(SDL_Renderer* renderer) {
        backgroundRect.draw(renderer);
    }
}