# Generated by Django 5.0.6 on 2024-05-28 02:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("base", "0003_rename_icos_app_icons"),
    ]

    operations = [
        migrations.AddField(
            model_name="app",
            name="app_file",
            field=models.FileField(null=True, upload_to="app_files"),
        ),
    ]