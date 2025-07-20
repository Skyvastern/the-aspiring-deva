import ffmpeg
import os
import base64
import tempfile
from src.models import AudioInputWithHistory
from src.init_services import client, modelName


def speech_to_speech(audio_input: AudioInputWithHistory):
    input_audio_bytes = base64.b64decode(audio_input.audio_base64)
    temp_dir = tempfile.gettempdir()

    # -------------------------SPEECH-TO-TEXT-------------------------
    input_wav_path = os.path.join(temp_dir, "input_audio.wav")
    
    # Save wav to file
    with open(input_wav_path, "wb") as save_wav_file:
        save_wav_file.write(input_audio_bytes)
    
    # Read and send wav file to OpenAI's speech to text API
    with open(input_wav_path, "rb") as read_wav_file:
        transcript = client.audio.translations.create(
            model="whisper-1",
            file=read_wav_file
        )
    
    # Remove file
    os.remove(input_wav_path)
    # ----------------------------------------------------------------

    # -------------------------TEXT-TO-TEXT-------------------------

    audio_input.history.append({
        "role": "user",
        "content": transcript.text
    })

    response = client.responses.create(
        model=modelName,
        input=audio_input.history
    )
    
    response_message = response.output_text
    # ----------------------------------------------------------------

    # -------------------------TEXT-TO-SPEECH-------------------------
    output_mp3_path = os.path.join(temp_dir, "output_audio.mp3")
    output_ogg_path = os.path.join(temp_dir, "output_audio.ogg")

    with client.audio.speech.with_streaming_response.create(
        model="gpt-4o-mini-tts",
        voice=audio_input.voice,
        input=response_message,
        response_format="mp3"
    ) as response:
        response.stream_to_file(output_mp3_path)

    # Convert mp3 to ogg
    ffmpeg.input(output_mp3_path).output(output_ogg_path, acodec="libvorbis").run()

    # Read ogg file and encode it in base64
    with open(output_ogg_path, "rb") as read_ogg_file:
        ogg_data = read_ogg_file.read()
    
    ogg_base64 = base64.b64encode(ogg_data).decode("utf-8")

    # Remove files
    os.remove(output_mp3_path)
    os.remove(output_ogg_path)
    
    # Return the base64 audio data and the subtitle
    return {
        "audio_base64": ogg_base64,
        "player_message": transcript.text,
        "npc_message": response_message
    }
    # ----------------------------------------------------------------