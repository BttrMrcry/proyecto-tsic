from django.db import models

# Create your models here.
class App(models.Model):
    name = models.CharField(max_length=200)
    description = models.TextField()
    icons = models.ImageField(upload_to="icons", null = True)
    app_file = models.FileField(upload_to="app_files", null = True)