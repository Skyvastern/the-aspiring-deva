from fastapi import APIRouter, HTTPException, Response
from src.models import TextToSpeechInput, AudioInput, AudioInputWithHistory, ChatInput
from src.init_services import client
from src.controllers.generate_random_characters_data import generate_random_characters_data
from src.controllers.text_generate import generate_text
from src.controllers.text_to_speech import text_to_speech
from src.controllers.speech_to_text import speech_to_text
from src.controllers.speech_to_speech import speech_to_speech



router = APIRouter()



@router.post("/text-to-speech")
def tts(tts_input: TextToSpeechInput):
    try:
        ogg_audio = text_to_speech(tts_input)
        return Response(content=ogg_audio, media_type="audio/ogg")
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))



@router.post("/speech-to-text")
def stt(audio_input: AudioInput):
    try:
        transcript = speech_to_text(audio_input)
        return {
            "text": transcript
        }
    
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error: {e}")



@router.post("/speech-to-speech")
def sts(audio_input: AudioInputWithHistory):
    try:
        result = speech_to_speech(audio_input)
        return result
    
    except Exception as e:
        print("Error: ", e)
        raise HTTPException(status_code=400, detail=f"Error: {e}")



@router.post("/textgen")
def textgen(chat_input: ChatInput):
    try:
        response_message = generate_text(chat_input)
        return {"npc_message": response_message}
    
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error: {e}")



@router.post("/get-random-characters")
def get_random_characters():
    try:
        return generate_random_characters_data()
    
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Error: {e}")