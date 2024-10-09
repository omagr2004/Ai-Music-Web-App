from django.http import JsonResponse 
from django.views.decorators.csrf import csrf_exempt
import openai
import os

# Load the OpenAI API key from environment variables
openai.api_key = os.getenv("OPENAI_API_KEY")

# Mock response for testing without an API key
MOCK_RESPONSE = {
    "choices": [
        {
            "message": {
                "content": "This is a mock response for the generated lyrics."
            }
        }
    ]
}

@csrf_exempt
def generate_lyrics(request):
    try:
        print(f"Request method: {request.method}")
        print(f"Request POST data: {request.POST}")
        if request.method == 'POST':
            prompt = request.POST.get('prompt')
            print(f"Prompt: {prompt}")
            if not openai.api_key:
                # Return mock response if no API key is provided
                lyrics = MOCK_RESPONSE['choices'][0]['message']['content']
                return JsonResponse({'lyrics': lyrics})

            response = openai.chat.completions.create(  # Updated method name
                model="gpt-3.5-turbo-instruct-0914",  # specify the model you're using
                messages=[
                    {"role": "system", "content": "You are a helpful assistant."},
                    {"role": "user", "content": prompt}
                ]
            )

            print(f"OpenAI response: {response}")
            lyrics = response.choices[0].message["content"].strip()  # Updated response format
            return JsonResponse({'lyrics': lyrics})
        return JsonResponse({'error': 'Invalid request method'}, status=400)
    except Exception as e:
        print(f"Error: {e}")
        return JsonResponse({'error': 'Internal server error'}, status=500)
