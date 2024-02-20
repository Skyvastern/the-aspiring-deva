import uvicorn
import ffmpeg
import os
import requests
import base64
from fastapi import FastAPI, HTTPException, Response
from models import TextToSpeechInput, AudioInput, QuestionInput
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()
client = OpenAI(
    api_key=os.getenv("OPENAI_API_KEY")
)


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.post("/text-to-speech/")
async def text_to_speech(tts_input: TextToSpeechInput):
    URL: str = "https://api.openai.com/v1/audio/speech"

    headers = {
        "Authorization": "Bearer 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",
        "Content-Type": "application/json"
    }

    request_payload = {
        "model": "tts-1",
        "input": tts_input.text,
        "voice": tts_input.voice
    }
    
    try:
        response = requests.post(URL, json=request_payload, headers=headers)

        if response.status_code == 200:
            mp3_audio = response.content

            # Save mp3 to a file
            with open("audio.mp3", "wb") as mp3_file:
                mp3_file.write(mp3_audio)
            
            # Convert mp3 to ogg
            ffmpeg.input("audio.mp3").output("audio.ogg", acodec="libvorbis").run()

            # Read ogg file and return it in response
            with open("audio.ogg", "rb") as ogg_file:
                ogg_audio = ogg_file.read()
            
            # Clean the audio files
            os.remove("audio.mp3")
            os.remove("audio.ogg")

            return Response(content=ogg_audio, media_type="audio/ogg")
        
        else:
            raise HTTPException(status_code=400, detail="Error from TTS API")
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))



@app.post("/speech-to-text/")
async def speech_to_text(audio_input: AudioInput):
    try:
        audio_bytes = base64.b64decode(audio_input.audio_base64)
        
        # Save wav to file
        with open("received_audio.wav", "wb") as save_wav_file:
            save_wav_file.write(audio_bytes)
        
        # Read and send wav file to OpenAI's speech to text API
        with open("received_audio.wav", "rb") as read_wav_file:
            transcript = client.audio.translations.create(
                model="whisper-1",
                file=read_wav_file
            )
        
        # Remove file
        os.remove("received_audio.wav")

        # Return the transcript
        return transcript
    
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error: {e}")



@app.post("/textgen/")
async def textgen(question_input: QuestionInput):
    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {
                    "role": "system",
                    "content": "You are an NPC in single player game world set in ancient period."
                },
                {
                    "role": "user",
                    "content": question_input.question
                }
            ]
        )

        response_message = response.choices[0].message
        return {"message": response_message}
    
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error: {e}")



@app.post("/speech-to-speech/")
async def speech_to_speech(audio_input: AudioInput):
    try:
        input_audio_bytes = base64.b64decode(audio_input.audio_base64)

        # -------------------------SPEECH-TO-TEXT-------------------------
        # Save wav to file
        with open("input_audio.wav", "wb") as save_wav_file:
            save_wav_file.write(input_audio_bytes)
        
        # Read and send wav file to OpenAI's speech to text API
        with open("input_audio.wav", "rb") as read_wav_file:
            transcript = client.audio.translations.create(
                model="whisper-1",
                file=read_wav_file
            )
        
        # Remove file
        os.remove("input_audio.wav")
        # ----------------------------------------------------------------

        # -------------------------TEXT-TO-TEXT-------------------------
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {
                    "role": "system",
                    "content": "You are a traveller walking in the streets of ancient Patliputra."
                },
                {
                    "role": "user",
                    "content": transcript.text
                }
            ]
        )

        response_message = response.choices[0].message.content
        # ----------------------------------------------------------------

        # -------------------------TEXT-TO-SPEECH-------------------------
        response = client.audio.speech.create(
            model="tts-1",
            voice="echo",
            input=response_message,
            response_format="mp3"
        )

        # Save mp3 to a file
        with open("output_audio.mp3", "wb") as save_mp3_file:
            save_mp3_file.write(response.content)
        
        # Convert mp3 to ogg
        ffmpeg.input("output_audio.mp3").output("output_audio.ogg", acodec="libvorbis").run()

        # Read ogg file and encode it in base64
        with open("output_audio.ogg", "rb") as read_ogg_file:
            ogg_data = read_ogg_file.read()
        
        ogg_base64 = base64.b64encode(ogg_data).decode("utf-8")

        # Remove files
        os.remove("output_audio.mp3")
        os.remove("output_audio.ogg")
        
        # Return the base64 audio data and the subtitle
        return {
            "audio_base64": ogg_base64,
            "subtitle": response_message
        }
        # ----------------------------------------------------------------
    
    except Exception as e:
        print("Error: ", e)
        raise HTTPException(status_code=400, detail=f"Error: {e}")


if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=8000, log_level="info", reload=True)