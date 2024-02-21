from pydantic import BaseModel


class TextToSpeechInput(BaseModel):
    text: str
    voice: str


class AudioInput(BaseModel):
    audio_base64: str
    history: list[dict]


class QuestionInput(BaseModel):
    question: str