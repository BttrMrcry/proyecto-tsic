from django.shortcuts import render
from django.http import HttpResponse, HttpResponseNotFound
from .models import App
# Create your views here
# Create your views here.
apps = [
    {
        "id": 1,
        "name": "app1",
        "description": "Descripción de la app 1"
    },
    
    {
        "id": 2,
        "name": "app2",
        "description": "Descripción de la app 2"
    }
]

def home(request):
    apps = App.objects.all()
    context = {"apps": apps}
    return render(request, "index.html", context)


def app(request, app_id):
    apps = App.objects.all()
    for app in apps:
        if app["id"] == int(app_id):
            context = {"app": app}
            return render(request, "app.html", context)

 
    return HttpResponseNotFound()