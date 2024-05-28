
from django.urls import path
from . import views
from django.conf.urls.static import static
from django.conf import settings

urlpatterns = [
    path("", views.home, name = "home"),
    path("app/<str:app_id>/", views.app, name = "app")
] +  static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
