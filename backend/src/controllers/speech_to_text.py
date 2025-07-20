import os
import base64
import tempfile
from src.models import AudioInput
from src.init_services import client


def speech_to_text(audio_input: AudioInput):
    audio_bytes = base64.b64decode(audio_input.audio_base64)
    temp_dir = tempfile.gettempdir()
    wav_path = os.path.join(temp_dir, "received_audio.wav")

    # Save wav to file
    with open(wav_path, "wb") as save_wav_file:
        save_wav_file.write(audio_bytes)
    
    # Read and send wav file to OpenAI's speech to text API
    with open(wav_path, "rb") as read_wav_file:
        transcript = client.audio.translations.create(
            model="whisper-1",
            file=read_wav_file
        )
    
    # Remove file
    os.remove(wav_path)

    # Return the transcript
    return transcript.text