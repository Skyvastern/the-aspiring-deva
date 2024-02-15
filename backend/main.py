import uvicorn
import ffmpeg
import os
import requests
from fastapi import FastAPI, HTTPException, Response
from models import TextToSpeechInput

app = FastAPI()


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


if __name__ == "__main__":
    uvicorn.run("main:app", host="127.0.0.1", port=8000, log_level="info", reload=True)