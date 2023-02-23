import std.stdio;
import std.conv;
import bindbc.sdl;
import mell.text;
import mell.sprite;

SDL_Renderer* renderer;

Text debugText;
float elapsed = 0;
int defaultFontSize = 14;
bool debugMode = true;
bool vsync = false;

void main()
{
	init_everything();
	  
	version (OSX){
		auto flags = SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE | SDL_WINDOW_MAXIMIZED | SDL_WINDOW_ALLOW_HIGHDPI;
		defaultFontSize = 28;
	} else {
		auto flags = SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE | SDL_WINDOW_MAXIMIZED;
		defaultFontSize = 14;
	}

	auto window = SDL_CreateWindow(
		"Mell Editor",
		SDL_WINDOWPOS_CENTERED,
		SDL_WINDOWPOS_CENTERED,
		1200, 720,	
		flags
	);
	
	if (!window) {
		throw new Exception("Failed to create window");
	}
	SDL_SetWindowMinimumSize(window, 1024, 768);

	auto rendererFlags = SDL_RENDERER_ACCELERATED;
	if (vsync) {
		SDL_GL_SetSwapInterval(1);
		rendererFlags |=  SDL_RENDERER_PRESENTVSYNC;
	} else {
		SDL_GL_SetSwapInterval(0);
	}
	renderer = SDL_CreateRenderer(window, -1, rendererFlags);
	if (!renderer) {
		throw new Exception("Failed to create renderer");
	}

	debugText = new Text("Screen: ", "./assets/fonts/OpenSans-Regular.ttf", defaultFontSize, 2, 0, Alignment.Left);	
	
	
	SDL_RendererInfo info;
	SDL_GetRendererInfo(renderer, &info);
	writeln("Renderer: ", info.name);
	
	SDL_SetRenderDrawColor(renderer, 88, 85, 83, 255);
	bool running = true;
	SDL_Event event; 

	while (running) {
		Uint64 start = SDL_GetPerformanceCounter();
		
		if (SDL_PollEvent(&event)) {
			switch (event.type) {
				case SDL_QUIT:
					running = false;
					break;
				case SDL_WINDOWEVENT:
					if (event.window.event == SDL_WINDOWEVENT_RESIZED) {
						int w, h;
						SDL_GetWindowSize(window, &w, &h);
					}
					break;
				case SDL_KEYDOWN:
					switch (event.key.keysym.sym) {
						case SDLK_ESCAPE:
							running = false;
							break;
						default:
							break;
					}
					break;
				case SDL_MOUSEBUTTONUP:
					if (event.button.button == 3) {
						debugMode = !debugMode;
					}
					break;
				default:
					break;
			}
		}
		
		SDL_RenderClear(renderer);

		

		if (debugMode) {
			draw_debug();
		}
		SDL_RenderPresent(renderer);

		Uint64 end = SDL_GetPerformanceCounter();
		elapsed = (end - start) / SDL_GetPerformanceFrequency().to!float;
	}
}

void draw_debug() {
	int x, y;
	SDL_GetMouseState(&x, &y);
	int w, h;
	SDL_GetWindowSize(SDL_GetWindowFromID(1), &w, &h);

	debugText.text = 
		"Screen: " ~ w.to!string ~ "x" ~ h.to!string ~ "\n" 
		~ "Mouse: " ~ x.to!string ~ "x" ~ y.to!string ~ "\n"
		~ "FPS: " ~ (1.0f / elapsed).to!string;

	debugText.draw(renderer);

}

void init_everything() {
	SDLSupport sdlStatus = loadSDL();
	if (sdlStatus != sdlSupport)
	{
		writeln("Failed loading SDL: ", sdlStatus);
		throw new Exception("Failed loading SDL");
	}

	if(loadSDLImage() < sdlImageSupport) { 
		throw new Exception("Failed loading BindBC SDL_image");
	}

	if (loadSDLTTF() < sdlTTFSupport) { 
		throw new Exception("Failed loading BindBC SDL_ttf");
	}

	if (loadSDLMixer() < sdlMixerSupport) { 
		throw new Exception("Failed loading BindBC SDL_Mixer");
	}

	if (SDL_Init(SDL_INIT_EVERYTHING) != 0)
	{
		writeln("Failed to initialize SDL: ", SDL_GetError());
	}
	
	auto flags = IMG_INIT_PNG | IMG_INIT_JPG;
	if(IMG_Init(flags) != flags) { 
		throw new Exception("Failed to initialize SDL_image");
	}

	if(TTF_Init() == -1) { 
		throw new Exception("Failed to initialize SDL_ttf");
	}

	if (Mix_Init(MIX_INIT_MP3) == -1) { 
		throw new Exception("Failed to initialize SDL_mixer");
	}
}