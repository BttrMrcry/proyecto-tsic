from django.shortcuts import render
from django.http import HttpResponse
# Create your views here.
apps = [
    {
        "name": "app1",
        "description": "Descripción de la app 1"
    },
    {
        "name": "app2",
        "description": "Descripción de la app 2"
    },
]

def home(request):
    context = {"apps": apps}
    return render(request, "home.html", context)


def app(request):
    return render(request, "app.html")