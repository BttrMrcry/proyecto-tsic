
from django.urls import path
from . import views

urlpatterns = [
    path("", views.home, name = "home"),
    path("app/<str:app_id>/", views.app, name = "app")
]
