from src.models import ChatInput
from src.init_services import client, modelName


def generate_text(chat_input: ChatInput):
    chat_input.history.append({
        "role": "user",
        "content": chat_input.player_message
    })

    response = client.responses.create(
        model=modelName,
        input=chat_input.history
    )

    return response.output_text