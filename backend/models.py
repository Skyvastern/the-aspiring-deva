from pydantic import BaseModel


class TextToSpeechInput(BaseModel):
    voice: str = "echo"
    npc_message: str


class AudioInput(BaseModel):
    voice: str = "echo"
    audio_base64: str
    history: list[dict]


class ChatInput(BaseModel):
    player_message: str
    history: list[dict]


class CharactersInstruction(BaseModel):
    instructions: str