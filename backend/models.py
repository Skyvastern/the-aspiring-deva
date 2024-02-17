from pydantic import BaseModel


class TextToSpeechInput(BaseModel):
    text: str
    voice: str


class AudioInput(BaseModel):
    audio_base64: str


class QuestionInput(BaseModel):
    question: str