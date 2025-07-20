from pydantic import BaseModel, Field
from src.init_services import client, modelName
from typing import Literal


INSTRUCTIONS = """
I (the user) am a aspiring deva working under Yamaraj (the God of Death).

You (AI) are gonna be a human who has come to the realm of Yama after his/her death.

My (the user) job is to assess you on your life by asking questions. In the end, I will judge whether you go to Heaven or you go to Hell.

You (AI) give responses in less than or equal to 100 words.

You (AI) only give conversation's response (nothing else).


You have to generate details of 10 individuals (5 good people and 5 bad people) in JSON format, with the following information -

{
name: String
age: int
gender: String ("male" or "female")
background_story: String (0-256 characters, and also mention the cause of your death)
voice: String ("onyx" (male), "echo" (male), "nova" (female), "fable" (female))
nature: {"truthfulness": int (0-10), "friendliness": int (0-10), "talkative": int (0-10)}
result: String (heaven or hell)
}

Above is the format for each character. So give the final response like this -

{characters: [{}, {}, {} ... ]}

Pick characters from the time period of ancient era.

Out of 10 characters, have stories from these places -

India: Good person
India: Bad person
Greece: Good person
Greece: Bad person
China: Good person
China: Bad person
Persia: Good person
Persia: Bad person
Egypt: Good person
Egypt: Bad person

Notes:
- Have 5 male and 5 female characters.
- In their stories, no need to explicity mention that they are from that country.
- Also, use character names that are not widely used these days.
"""


class CharacterNature(BaseModel):
    truthfulness: int = Field(ge=0, le=10)
    friendliness: int = Field(ge=0, le=10)
    talkative: int = Field(ge=0, le=10)

class CharacterData(BaseModel):
    name: str
    age: float
    gender: Literal["male", "female"]
    background_story: str = Field(min_length=1, max_length=256)
    voice: Literal["onyx", "echo", "nova", "fable"]
    nature: CharacterNature
    result: Literal["heaven", "hell"]

class Characters(BaseModel):
    characters: list[CharacterData]


def generate_random_characters_data():
    response = client.responses.parse(
        model=modelName,
        input=[{
            "role": "system",
            "content": INSTRUCTIONS
        }],
        text_format=Characters
    )
    
    response_message = response.output_parsed
    return response_message