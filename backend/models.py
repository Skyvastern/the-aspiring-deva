from pydantic import BaseModel


class TextToSpeechInput(BaseModel):
    text: str
    voice: str