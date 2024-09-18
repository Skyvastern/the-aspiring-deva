# The Aspiring Deva
This game is a small project I made as a fun experiment to have generative AI drive the core gameplay.

You can check out the [video devlog here](https://www.youtube.com/watch?v=3ewOax-F45g), and the [written devlog here](https://skyvastern.com/blogs/i-created-a-game-that-uses-generative-ai-to-drive-the-main-gameplay/).


## Setup
- The backend folder contains the Python FastAPI server.
- The frontend folder contains the Godot project.

### Backend Setup
1. Open terminal, and head over to backend folder.
2. Create and activate [python environment](https://docs.python.org/3/library/venv.html).
3. Install python packages using `pip install -r requirements.txt`
4. Duplicate `.env.example` and name the new one to `.env`.
5. In `.env`, fill in the value of `OPENAI_API_KEY` with your OpenAI's account API key.
6. Start the server using `python main.py` 🚀


### Frontend Setup
1. Open the `frontend` folder in Godot.
2. Duplicate `res://main/common/env/env_example.gd` and name the new one `env.gd`
3. Change class name to `class_name ENV` in `env.gd`
4. Set `BASE_URL` to wherever you've deployed the server. If you have run it locally on your system, then set the value to `http://127.0.0.1:8000`
5. That's it, now run the game and have fun! 😀

## Attributions

- Game Engine: Godot
    - URL: https://godotengine.org/

- 3D Characters: Ninja & Erika Archer
    - URL: https://www.mixamo.com/

- Music: Royal Coupling
    - Author: Kevin MacLeod
    - URL: https://incompetech.com/
    - License: https://creativecommons.org/licenses/by/4.0/

- Kick SFX: Socapex - big punch
    - Author: tarfmagougou
    - URL: https://opengameart.org/content/punches-hits-swords-and-squishes
    - License: https://creativecommons.org/licenses/by-sa/3.0/

- Male Scream SFX: aargh4.ogg
    - Author: congusbongus
    - URL: https://opengameart.org/content/aargh-male-screams
    - License: https://creativecommons.org/licenses/by/3.0/

- Female Scream SFX: female_scream_1.ogg
    - Author: nocturnalvanguard
    - URL: https://opengameart.org/content/female-scream-1
    - License: https://creativecommons.org/publicdomain/zero/1.0/

- Switches Heaven & Yama SFX: magical_1.ogg & magical_4.ogg
    - Author: jaggedstone
    - URL: https://opengameart.org/content/magic-spell-sfx
    - License: https://creativecommons.org/publicdomain/zero/1.0/

- Switch Hell SFX: rock_breaking.ogg
    - Author: Blender Foundation / Lamoot
    - URL: https://opengameart.org/content/rockbreaking
    - License: https://creativecommons.org/licenses/by/3.0/

- UI SFX: click3.ogg & rollover5.ogg
    - Author: Kenney Vleugels
    - URL: https://www.kenney.nl/assets/ui-audio
    - License: https://creativecommons.org/publicdomain/zero/1.0/
