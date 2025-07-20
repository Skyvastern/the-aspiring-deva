import ffmpeg
import os
import tempfile
from src.models import TextToSpeechInput
from src.init_services import client


def text_to_speech(tts_input: TextToSpeechInput):
    temp_dir = tempfile.gettempdir()
    mp3_path = os.path.join(temp_dir, "audio.mp3")
    ogg_path = os.path.join(temp_dir, "audio.ogg")

    with client.audio.speech.with_streaming_response.create(
        model="gpt-4o-mini-tts",
        voice=tts_input.voice,
        input=tts_input.npc_message,
        response_format="mp3"
    ) as response:
        response.stream_to_file(mp3_path)

    # Convert mp3 to ogg
    ffmpeg.input(mp3_path).output(ogg_path, acodec="libvorbis").run()

    # Read ogg file and return it in response
    with open(ogg_path, "rb") as ogg_file:
        ogg_audio = ogg_file.read()
    
    # Clean the audio files
    os.remove(mp3_path)
    os.remove(ogg_path)

    return ogg_audio