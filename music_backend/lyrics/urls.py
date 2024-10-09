from django.urls import path
from .views import generate_lyrics

urlpatterns = [
    path('generate_lyrics/', generate_lyrics, name='generate_lyrics'),
]